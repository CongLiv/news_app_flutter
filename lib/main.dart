import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_app_flutter_demo/helpers/firebase_config.dart';
import 'package:news_app_flutter_demo/providers/themeProvider.dart';
import 'screens/article/homepage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseConfig.initializeApp();
  await FirebaseConfig.initRemoteConfig();
  runApp(ProviderScope(child: MyApp()));
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
