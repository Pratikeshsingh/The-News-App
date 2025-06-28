// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:inshort_clone/view/app_base/app_base.dart';
import 'package:inshort_clone/view/discover_screen/discover.dart';

class FeedProvider extends ChangeNotifier {
  String? _appBarTitle;
  int _activeCategory = 1;
  bool _hasDataLoaded = false;
  bool _searchAppBarVisible = true;
  bool _appBarVisible = false;
  bool _watermarkVisible = false;
  bool _feedBottomActionbarVisible = false;
  int _currentArticleIndex = 0;
  late PageController _feedPageController;
  late PageController _screenController;
  List<Widget> _baseScreen = [
    DiscoverScreen(),
    BuildNewsScreen(),
  ];
  String _newsURL = "https://google.com/";
  bool _webviewAdded = false;
  List<String> _lastGetRequest = [];

  //

  bool get getHasDataLoaded => this._hasDataLoaded;

  int get getActiveCategory => this._activeCategory;

  String? get getAppBarTitle => _appBarTitle;

  bool get getSearchAppBarVisible => this._searchAppBarVisible;

  bool get getAppBarVisible => this._appBarVisible;

  bool get getWatermarkVisible => this._watermarkVisible;

  bool get getFeedBottomActionbarVisible => this._feedBottomActionbarVisible;

  int get getCurrentArticleIndex => this._currentArticleIndex;

  PageController get getFeedPageController => this._feedPageController;

  PageController get getScreenController => this._screenController;

  List<Widget> get getBaseScreenList => this._baseScreen;

  String get getNewsURL => _newsURL;

  List<String> get getLastGetRequest => _lastGetRequest;

  bool get webviewAdded => _webviewAdded;

  ///

  void setActiveCategory(int activeCategory) {
    this._activeCategory = activeCategory;
    notifyListeners();
  }

  void setAppBarTitle(String appBarTitle) {
    this._appBarTitle = appBarTitle;
    notifyListeners();
  }

  void setDataLoaded(bool status) {
    this._hasDataLoaded = status;
    notifyListeners();
  }

  void setSearchAppBarVisible(bool searchAppBarVisible) {
    this._searchAppBarVisible = searchAppBarVisible;
    notifyListeners();
  }

  void setAppBarVisible(bool appBarVisible) {
    this._appBarVisible = appBarVisible;
    notifyListeners();
  }

  void setWatermarkVisible(bool visible) {
    this._watermarkVisible = visible;
    notifyListeners();
  }

  void setFeedBottomActionbarVisible(bool feedBottomActionbarVisible) {
    this._feedBottomActionbarVisible = feedBottomActionbarVisible;
    notifyListeners();
  }

  void setCurrentArticleIndex(int currentArticleIndex) {
    this._currentArticleIndex = currentArticleIndex;
    notifyListeners();
  }

  void setFeedPageController(PageController pageController) {
    this._feedPageController = pageController;
    notifyListeners();
  }

  void setScreenController(PageController pageController) {
    this._screenController = pageController;
    notifyListeners();
  }

  void addWebScreen(Widget widget) {
    _baseScreen.add(widget);
    notifyListeners();
  }

  void setNewsURL(String newsURL) {
    this._newsURL = newsURL;
    notifyListeners();
  }

  void setWebViewAdded() {
    this._webviewAdded = true;
    notifyListeners();
  }

  void setLastGetRequest(String request, String value) {
    _lastGetRequest.clear();
    _lastGetRequest.add(request);
    _lastGetRequest.add(value);
    notifyListeners();
  }
}
