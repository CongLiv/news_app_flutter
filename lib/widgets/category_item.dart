import 'package:flutter/material.dart';
import 'package:news_app_flutter_demo/firebase_tools/firebase_analyst.dart';

import '../screens/article/category_news.dart';

class CategoryItem extends StatelessWidget {
  final String imageUrl;
  final String name;

  CategoryItem({
    required this.name,
    required this.imageUrl,
  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await FirebaseAnalyst.logCategoryClickEvent(name);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (ctx) => CategoryNewsScreen(
              categoryName: name,
            ),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(
          top: 10,
          bottom: 5,
        ),
        width: double.infinity,
        height: 110,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: DecorationImage(
            colorFilter: ColorFilter.mode(
              Colors.black54,
              BlendMode.darken,
            ),
            image: AssetImage(imageUrl),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Text(
            name.toUpperCase(),
            style: TextStyle(
              fontFamily: 'FS PFBeauSansPro',
              color: Colors.white,
              fontSize: 25,
              fontWeight: FontWeight.w900,
              letterSpacing: 3,
            ),
          ),
        ),
      ),
    );
  }
}
