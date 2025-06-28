// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:inshort_clone/model/news_model.dart';
import 'package:inshort_clone/view/app_base/app_base.dart';
import 'package:inshort_clone/view/bookmarked_screen/bookmark.dart';
import 'package:inshort_clone/view/discover_screen/discover.dart';
import 'package:inshort_clone/view/feed_screen/feed.dart';
import 'package:inshort_clone/view/photo_view/photo_expanded_screen.dart';
import 'package:inshort_clone/view/search_screen/search.dart';
import 'package:inshort_clone/view/settings_screen/settings.dart';
import 'package:inshort_clone/view/web_screen/web.dart';

class Routes {
  static const searchScreen = '/search-screen';
  static const settingsScreen = '/settings-screen';
  static const bookmarkScreen = '/bookmark-screen';
  static const webScreen = '/web-screen';
  static const discoverScreen = '/discover-screen';
  static const feedScreen = '/feed-screen';
  static const appBase = '/';
  static const expandedImageView = '/expandedImageView';

  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  static NavigatorState? get navigator => navigatorKey.currentState;

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case searchScreen:
        return MaterialPageRoute(
          builder: (_) => SearchScreen(),
          settings: settings,
        );

      case settingsScreen:
        return MaterialPageRoute(
          builder: (_) => SettingsScreen(),
          settings: settings,
        );

      case bookmarkScreen:
        return MaterialPageRoute(
          builder: (_) => BookmarkScreen(),
          settings: settings,
        );

      case webScreen:
        if (args is! WebViewArguments) {
          return _errorRoute("Invalid arguments for WebScreen");
        }
        final typedArgs = args as WebViewArguments;
        return MaterialPageRoute(
          builder: (_) => WebScreen(
            url: typedArgs.url,
            isFromBottom: typedArgs.isFromBottom,
          ),
          settings: settings,
        );

      case discoverScreen:
        return MaterialPageRoute(
          builder: (_) => DiscoverScreen(),
          settings: settings,
        );

      case expandedImageView:
        if (args is! ExpandedImageViewArguments) {
          return _errorRoute("Invalid arguments for ExpandedImageView");
        }
        final typedArgs = args as ExpandedImageViewArguments;
        return MaterialPageRoute(
          builder: (_) => ExpandedImageView(
            image: typedArgs.image,
          ),
          settings: settings,
        );

      case feedScreen:
        if (args is! FeedScreenArguments) {
          return _errorRoute("Invalid arguments for FeedScreen");
        }
        final typedArgs = args as FeedScreenArguments;
        return MaterialPageRoute(
          builder: (_) => FeedScreen(
            key: typedArgs.key,
            articleIndex: typedArgs.articleIndex,
            articles: typedArgs.articles,
            isFromSearch: typedArgs.isFromSearch,
          ),
          settings: settings,
        );

      case appBase:
        return MaterialPageRoute(
          builder: (_) => AppBase(),
          settings: settings,
        );

      default:
        return _errorRoute("Unknown route: ${settings.name}");
    }
  }

  static Route<dynamic> _errorRoute(String message) {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(title: Text('Routing Error')),
        body: Center(child: Text(message)),
      ),
    );
  }
}

//**************************************************************************
// Arguments holder classes
//***************************************************************************

class FeedScreenArguments {
  final Key? key;
  final int articleIndex;
  final List<Articles> articles;
  final bool isFromSearch;

  FeedScreenArguments({
    this.key,
    required this.articleIndex,
    required this.articles,
    required this.isFromSearch,
  });
}

class ExpandedImageViewArguments {
  final String image;

  ExpandedImageViewArguments({required this.image});
}

class WebViewArguments {
  final String url;
  final bool isFromBottom;

  WebViewArguments({required this.url, required this.isFromBottom});
}
