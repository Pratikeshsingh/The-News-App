// Dart imports:
import 'dart:async';

class FeedController {
  static StreamController<int> _currentPage = StreamController<int>.broadcast();
  static StreamController<int> _currentArticleIndex =
      StreamController<int>.broadcast();

  static Stream<int> get _currentPageStream => _currentPage.stream;
  static Stream<int> get _currentArticleIndexStream =>
      _currentArticleIndex.stream;

  static void addCurrentPage(int page) {
    _currentPage.sink.add(page);
  }

  static void addCurrentArticleIndex(int index) {
    _currentArticleIndex.sink.add(index);
  }

  static int getCurrentPage(Function function) {
    int page = 1;
    _currentPageStream.listen(
      (onData) {
        if (onData != null) {
          page = onData;
          function(onData);
        }
      },
    );
    return page;
  }

  static int getCurrentArticleIndex(Function function) {
    int index = 0;
    _currentArticleIndexStream.listen(
      (onData) {
        if (onData != null) {
          index = onData;
          function(onData);
        }
      },
    );
    return index;
  }

  static void dispose() {
    _currentArticleIndex.close();
    _currentPage.close();
  }
}
