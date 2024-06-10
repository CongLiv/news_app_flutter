import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_app_flutter_demo/providers/themeProvider.dart';
import 'firebase_tools/firebase_config.dart';
import 'screens/article/homepage.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

void main() async {
  runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await FirebaseConfig.initializeApp();
    await FirebaseConfig.initRemoteConfig();
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
    runApp(ProviderScope(child: MyApp()));
  }, (error, stackTrace) {
    FirebaseCrashlytics.instance.recordError(error, stackTrace);
  });
}

class MyApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themePro = ref.watch(themeProvider);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: themePro,
      home: Homepage(),
    );
  }
}
