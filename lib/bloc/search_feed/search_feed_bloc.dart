// Flutter imports:
import 'package:flutter/cupertino.dart';

// Package imports:
import 'package:bloc/bloc.dart';

// Project imports:
import 'package:inshort_clone/model/news_model.dart';
import 'package:inshort_clone/services/news/news_service.dart';
import 'search_feed_event.dart';
import 'search_feed_state.dart';

class SearchFeedBloc extends Bloc<SearchFeedEvent, SearchFeedState> {
  final NewsFeedRepository repository;
  SearchFeedBloc({required this.repository}) : super(SearchFeedInitialState()) {
    on<FetchNewsBySearchQueryEvent>(_onFetchNewsBySearchQuery);
  }

  Future<void> _onFetchNewsBySearchQuery(
      FetchNewsBySearchQueryEvent event, Emitter<SearchFeedState> emit) async {
    emit(SearchFeedLoadingState());
    try {
      final List<Articles> news =
          await repository.getNewsBySearchQuery(event.query);
      emit(SearchFeedLoadedState(news: news));
    } catch (e) {
      emit(SearchFeedErrorState(message: e.toString()));
    }
  }
}
