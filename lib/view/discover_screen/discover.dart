// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

// Project imports:
import 'package:inshort_clone/application_localization.dart';
import 'package:inshort_clone/bloc/feed/news_feed_bloc.dart';
import 'package:inshort_clone/bloc/feed/news_feed_event.dart';
import 'package:inshort_clone/controller/feed_controller.dart';
import 'package:inshort_clone/controller/provider.dart';
import 'package:inshort_clone/view/discover_screen/widgets/category_card.dart';
import 'package:inshort_clone/view/discover_screen/widgets/headline.dart';
import 'package:inshort_clone/view/discover_screen/widgets/topics_card.dart';
import 'package:inshort_clone/view/discover_screen/widgets/app_bar.dart';

class _TopicData {
  final String key;
  final String icon;
  final bool isCategory;
  final String value;

  const _TopicData(
      {required this.key,
      required this.icon,
      required this.isCategory,
      required this.value});
}
class DiscoverScreen extends StatefulWidget {
  @override
  _DiscoverScreenState createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  var bloc;
  final List<_TopicData> _allTopics = const [
    _TopicData(key: 'coronavirus', icon: 'coronavirus', isCategory: false, value: 'coronavirus'),
    _TopicData(key: 'india', icon: 'india', isCategory: false, value: 'india'),
    _TopicData(key: 'business', icon: 'business', isCategory: true, value: 'business'),
    _TopicData(key: 'politics', icon: 'politics', isCategory: false, value: 'politics'),
    _TopicData(key: 'sports', icon: 'sports', isCategory: true, value: 'sports'),
    _TopicData(key: 'technology', icon: 'technology', isCategory: true, value: 'technology'),
    _TopicData(key: 'startups', icon: 'startups', isCategory: false, value: 'startups'),
    _TopicData(key: 'entertainment', icon: 'entertainment', isCategory: true, value: 'entertainment'),
    _TopicData(key: 'education', icon: 'education', isCategory: false, value: 'education'),
    _TopicData(key: 'automobile', icon: 'automobile', isCategory: false, value: 'automobile'),
    _TopicData(key: 'science', icon: 'science', isCategory: true, value: 'science'),
    _TopicData(key: 'travel', icon: 'travel', isCategory: false, value: 'travel'),
    _TopicData(key: 'fashion', icon: 'fashion', isCategory: false, value: 'fashion'),
  ];

  List<_TopicData> _visibleTopics = [];
  bool _loadingTopics = true;
  bool _hasOther = false;

  @override
  void initState() {
    bloc = BlocProvider.of<NewsFeedBloc>(context);
    _prepareTopics();
    super.initState();
  }

  Future<void> _prepareTopics() async {
    final repo = bloc.repository;
    List<_TopicData> visible = [];
    bool other = false;
    for (final t in _allTopics) {
      try {
        final news = t.isCategory
            ? await repo.getNewsByCategory(t.value)
            : await repo.getNewsByTopic(t.value);
        if (news.isNotEmpty) {
          visible.add(t);
        } else {
          other = true;
        }
      } catch (_) {
        other = true;
      }
    }
    setState(() {
      _visibleTopics = visible;
      _hasOther = other;
      _loadingTopics = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FeedProvider>(context, listen: false);
    provider.setAppBarVisible(true);

    return Scaffold(
      appBar: appSearchBar(context),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 16,
            ),
            headLine(AppLocalizations.of(context).translate("categories")),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Consumer<FeedProvider>(
                  builder: (context, value, child) => Row(
                    children: <Widget>[
                      CategoryCard(
                        title:
                            AppLocalizations.of(context).translate("my_feed"),
                        icon: "all",
                        active: provider.getActiveCategory == 1,
                        onTap: () {
                          provider.setActiveCategory(1);
                          provider.setAppBarTitle(AppLocalizations.of(context)
                              .translate("my_feed"));

                          bloc.add(
                            FetchNewsByCategoryEvent(category: "general"),
                          );
                        },
                      ),
                      CategoryCard(
                        title:
                            AppLocalizations.of(context).translate("trending"),
                        icon: "trending",
                        active: provider.getActiveCategory == 2,
                        onTap: () {
                          provider.setActiveCategory(2);
                          provider.setAppBarTitle(AppLocalizations.of(context)
                              .translate("trending"));

                          bloc.add(
                            FetchNewsByTopicEvent(topic: "trending"),
                          );
                        },
                      ),
                      CategoryCard(
                        title:
                            AppLocalizations.of(context).translate("bookmark"),
                        icon: "bookmark",
                        active: provider.getActiveCategory == 3,
                        onTap: () {
                          provider.setActiveCategory(3);
                          provider.setAppBarTitle(AppLocalizations.of(context)
                              .translate("bookmark"));

                          bloc.add(
                            FetchNewsFromLocalStorageEvent(box: 'bookmarks'),
                          );
                        },
                      ),
                      CategoryCard(
                        title:
                            AppLocalizations.of(context).translate("unreads"),
                        icon: "unread",
                        active: provider.getActiveCategory == 4,
                        onTap: () {
                          provider.setActiveCategory(4);
                          provider.setAppBarTitle(AppLocalizations.of(context)
                              .translate("unreads"));

                          bloc.add(
                            FetchNewsFromLocalStorageEvent(box: 'unreads'),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 16,
            ),
            headLine(AppLocalizations.of(context).translate("sugested_topics")),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: _loadingTopics
                  ? Center(child: CircularProgressIndicator())
                  : GridView.count(
                      shrinkWrap: true,
                      childAspectRatio: (1 / 1.4),
                      physics: NeverScrollableScrollPhysics(),
                      crossAxisCount: 3,
                      children: <Widget>[
                        for (final topic in _visibleTopics)
                          TopicCard(
                            title: AppLocalizations.of(context)
                                .translate(topic.key),
                            icon: topic.icon,
                            onTap: () {
                              provider.setAppBarTitle(
                                  AppLocalizations.of(context).translate(topic.key));
                              FeedController.addCurrentPage(1);
                              bloc.add(
                                topic.isCategory
                                    ? FetchNewsByCategoryEvent(category: topic.value)
                                    : FetchNewsByTopicEvent(topic: topic.value),
                              );
                            },
                          ),
                        if (_hasOther)
                          TopicCard(
                            title: AppLocalizations.of(context)
                                .translate('others'),
                            icon: 'international',
                            onTap: () {
                              provider.setAppBarTitle(AppLocalizations.of(context)
                                  .translate('others'));
                              FeedController.addCurrentPage(1);
                              bloc.add(
                                FetchNewsByCategoryEvent(category: 'general'),
                              );
                            },
                          ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
