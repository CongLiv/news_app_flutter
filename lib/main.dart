import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:news_app_flutter_demo/providers/themeProvider.dart';
import 'package:provider/provider.dart';
import './providers/categories.dart';
import './providers/news.dart';
import 'firebase_options.dart';
import 'screens/article/homepage.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    ChangeNotifierProvider(   // need add theme provider first
      create: (context) => ThemeProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: News(),
        ),
        ChangeNotifierProvider.value(
          value: Categories(),
        ),

      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: Provider.of<ThemeProvider>(context).themData,
        home: Homepage(),
      ),
    );
  }
}
