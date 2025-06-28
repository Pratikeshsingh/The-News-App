// Flutter imports:
import 'package:flutter/cupertino.dart';

// Package imports:
import 'package:bloc/bloc.dart';

// Project imports:
import 'package:inshort_clone/bloc/feed/news_feed_event.dart';
import 'package:inshort_clone/bloc/feed/news_feed_state.dart';
import 'package:inshort_clone/model/news_model.dart';
import 'package:inshort_clone/services/news/news_service.dart';

class NewsFeedBloc extends Bloc<NewsFeedEvent, NewsFeedState> {
  final NewsFeedRepository repository;
  NewsFeedBloc({required this.repository}) : super(NewsFeedInitialState()) {
    on<FetchNewsByCategoryEvent>(_onFetchNewsByCategory);
    on<FetchNewsByTopicEvent>(_onFetchNewsByTopic);
    on<FetchNewsFromLocalStorageEvent>(_onFetchNewsFromLocalStorage);
  }

  Future<void> _onFetchNewsByCategory(
      FetchNewsByCategoryEvent event, Emitter<NewsFeedState> emit) async {
    emit(NewsFeedLoadingState());
    try {
      final List<Articles> news =
          await repository.getNewsByCategory(event.category);
      emit(NewsFeedLoadedState(news: news));
    } catch (e) {
      emit(NewsFeedErrorState(message: e.toString()));
    }
  }

  Future<void> _onFetchNewsByTopic(
      FetchNewsByTopicEvent event, Emitter<NewsFeedState> emit) async {
    emit(NewsFeedLoadingState());
    try {
      final List<Articles> news = await repository.getNewsByTopic(event.topic);
      emit(NewsFeedLoadedState(news: news));
    } catch (e) {
      emit(NewsFeedErrorState(message: e.toString()));
    }
  }

  Future<void> _onFetchNewsFromLocalStorage(
      FetchNewsFromLocalStorageEvent event, Emitter<NewsFeedState> emit) async {
    emit(NewsFeedLoadingState());
    try {
      final List<Articles> news = repository.getNewsFromLocalStorage(event.box);
      emit(NewsFeedLoadedState(news: news));
    } catch (e) {
      emit(NewsFeedErrorState(message: e.toString()));
    }
  }
}
