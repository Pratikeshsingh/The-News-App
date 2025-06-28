// Package imports:
import 'package:hive/hive.dart';

part 'news_model.g.dart';

class NewsModel {
  /// Status returned from API. Non-nullable.
  final String status;

  /// Total results returned from API. Non-nullable.
  final int totalResults;

  /// List of article objects associated with the response.
  final List<Articles> articles;

  NewsModel({
    required this.status,
    required this.totalResults,
    required this.articles,
  });

  NewsModel.fromJson(Map<String, dynamic> json)
      : status = json['status'] ?? '',
        totalResults = json['totalResults'] ?? 0,
        articles = json['articles'] != null
            ? List<Articles>.from(
                (json['articles'] as List).map((v) => Articles.fromJson(v)))
            : <Articles>[];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = this.status;
    data['totalResults'] = this.totalResults;
    if (articles.isNotEmpty) {
      data['articles'] = articles.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

@HiveType(typeId: 101)
class Articles {
  @HiveField(0)
  String? sourceName;
  @HiveField(1)
  String author;
  @HiveField(2)
  String title;
  @HiveField(3)
  String description;
  @HiveField(4)
  String url;
  @HiveField(5)
  String urlToImage;
  @HiveField(6)
  String publishedAt;
  @HiveField(7)
  String content;

  Articles({
    this.sourceName,
    required this.author,
    required this.title,
    required this.description,
    required this.url,
    required this.urlToImage,
    required this.publishedAt,
    required this.content,
  });

  Articles.fromJson(Map<String, dynamic> json)
      : sourceName = json['source'] != null
            ? Source.fromJson(json['source']).name
            : null,
        author = json['author'] ?? '',
        title = json['title'] ?? '',
        description = json['description'] ?? '',
        url = json['url'] ?? '',
        urlToImage = json['urlToImage'] ?? '',
        publishedAt = json['publishedAt'] ?? '',
        content = json['content'] ?? '';

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.sourceName != null) {
      data['sourceName'] = this.sourceName;
    }
    data['author'] = this.author;
    data['title'] = this.title;
    data['description'] = this.description;
    data['url'] = this.url;
    data['urlToImage'] = this.urlToImage;
    data['publishedAt'] = this.publishedAt;
    data['content'] = this.content;
    return data;
  }
}

class Source {
  String id;
  String name;

  Source({
    required this.id,
    required this.name,
  });

  Source.fromJson(Map<String, dynamic> json)
      : id = json['id'] ?? '',
        name = json['name'] ?? '';

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}
