import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:inshort_clone/model/news_model.dart';

import 'package:provider/provider.dart';
import 'package:inshort_clone/app/app.dart';
import 'package:inshort_clone/controller/provider.dart';
import 'package:inshort_clone/controller/settings.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Initialize Hive
    await Hive.initFlutter();

    // Register adapters
    Hive.registerAdapter(ArticlesAdapter());

    // Open boxes with proper types
    await Hive.openBox<Articles>('bookmarks');
    await Hive.openBox<Articles>('topNews');
    await Hive.openBox<Articles>('categories');
    await Hive.openBox<Articles>('unreads');
    await Hive.openBox('settingsBox');

    runApp(MyApp());
  } catch (e, stackTrace) {
    // Log error to console
    print('❌ Error during app initialization: $e');
    print('🔍 Stack trace:\n$stackTrace');

    // Run a fallback UI that shows an error message
    runApp(MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text(
            'Something went wrong.\nCheck the logs for more details.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
    ));
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FeedProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
      ],
      child: App(),
    );
  }
}
