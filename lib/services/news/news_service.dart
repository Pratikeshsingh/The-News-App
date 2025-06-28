// Flutter imports:
import 'package:flutter/material.dart';
import 'package:inshort_clone/common/utils/logger.dart';

// Package imports:
import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

// Project imports:
import 'package:inshort_clone/app/dio/dio.dart';
import 'package:inshort_clone/controller/provider.dart';
import 'package:inshort_clone/controller/settings.dart';
import 'package:inshort_clone/model/news_model.dart';
import 'package:inshort_clone/services/news/offline_service.dart';

String _computeFromDate() {
  final DateTime fromDate = DateTime.now().subtract(const Duration(days: 7));
  return DateFormat('yyyy-MM-dd').format(fromDate);
}

abstract class NewsFeedRepository {
  Future<List<Articles>> getNewsByTopic(String topic);

  Future<List<Articles>> getNewsByCategory(String category);

  Future<List<Articles>> getNewsBySearchQuery(String query);

  List<Articles> getNewsFromLocalStorage(String box);
}

class NewsFeedRepositoryImpl implements NewsFeedRepository {
  final BuildContext context;
  NewsFeedRepositoryImpl(this.context);

  List<Articles> _filterArticles(List<Articles> articles) {
    final DateTime cutoff =
        DateTime.now().subtract(const Duration(days: 7));
    return articles
        .where((article) {
          try {
            final DateTime published = DateTime.parse(article.publishedAt);
            return !published.isBefore(cutoff);
          } catch (_) {
            return false;
          }
        })
        .toList();
  }

  @override
  Future<List<Articles>> getNewsByTopic(String topic) async {
    final settingsProvider =
        Provider.of<SettingsProvider>(context, listen: false);
    final String url =
        "everything?q=$topic&from=${_computeFromDate()}&language=${settingsProvider.getActiveLanguageCode()}";
    final provider = Provider.of<FeedProvider>(context, listen: false);

    provider.setDataLoaded(false);
    provider.setLastGetRequest("getNewsByTopic", topic);
    logMessage('getNewsByTopic $topic');

    Response response = await GetDio.getDio().get(url);
    if (response.statusCode == 200) {
      List<Articles> articles =
          _filterArticles(NewsModel.fromJson(response.data).articles);

      provider.setDataLoaded(true);
      addArticlesToUnreads(articles);

      return articles;
    } else {
      provider.setDataLoaded(true);
      throw Exception();
    }
  }

  @override
  Future<List<Articles>> getNewsByCategory(String category) async {
    final settingsProvider =
        Provider.of<SettingsProvider>(context, listen: false);
    final String url =
        "top-headlines?country=${settingsProvider.getActiveCountryCode()}&category=$category";
    final provider = Provider.of<FeedProvider>(context, listen: false);

    provider.setDataLoaded(false);
    provider.setLastGetRequest("getNewsByCategory", category);

    Response response = await GetDio.getDio().get(url);
    if (response.statusCode == 200) {
      List<Articles> articles =
          _filterArticles(NewsModel.fromJson(response.data).articles);

      if (articles.isEmpty && category == "general") {
        final String fallbackUrl = "top-headlines?country=${settingsProvider.getActiveCountryCode()}";
        Response fallbackResponse = await GetDio.getDio().get(fallbackUrl);
        if (fallbackResponse.statusCode == 200) {
          articles = _filterArticles(NewsModel.fromJson(fallbackResponse.data).articles);
          articles.shuffle();
        }
      }
      provider.setDataLoaded(true);
      addArticlesToUnreads(articles);

      return articles;
    } else {
      provider.setDataLoaded(true);
      throw Exception();
    }
  }

  @override
  Future<List<Articles>> getNewsBySearchQuery(String query) async {
    final settingsProvider =
        Provider.of<SettingsProvider>(context, listen: false);
    final provider = Provider.of<FeedProvider>(context, listen: false);

    provider.setDataLoaded(false);

    final String url =
        "everything?q=$query&from=${_computeFromDate()}&language=${settingsProvider.getActiveLanguageCode()}";

    Response response = await GetDio.getDio().get(url);
    if (response.statusCode == 200) {
      List<Articles> articles =
          _filterArticles(NewsModel.fromJson(response.data).articles);

      addArticlesToUnreads(articles);
      provider.setDataLoaded(true);
      return articles;
    } else {
      provider.setDataLoaded(true);
      throw Exception();
    }
  }

  @override
  List<Articles> getNewsFromLocalStorage(String fromBox) {
    List<Articles> articles = [];
    final Box<Articles> hiveBox = Hive.box<Articles>(fromBox);
    final provider = Provider.of<FeedProvider>(context, listen: false);

    provider.setLastGetRequest("getNewsFromLocalStorage", fromBox);

    logMessage(fromBox);

    if (hiveBox.length > 0) {
      for (int i = 0; i < hiveBox.length; i++) {
        final Articles? article = hiveBox.getAt(i);
        if (article != null) {
          articles.add(article);
        }
      }
      provider.setDataLoaded(true);

      return _filterArticles(articles);
    } else {
      provider.setDataLoaded(true);
      List<Articles> articles = [];
      return articles;
    }
  }
}
