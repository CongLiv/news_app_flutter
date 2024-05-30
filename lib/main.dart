import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './providers/categories.dart';
import './providers/news.dart';
import './screens/homepage.dart';
import 'helpers/const_data.dart';

void main() => runApp(MyApp());

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
        theme: ThemeData(
          primaryColor: redViettel,
          primaryColorLight: redViettel,
          hintColor: redViettel,
        ),
        home: Homepage(),
      ),
    );
  }
}
