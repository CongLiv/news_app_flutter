import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:news_app_flutter_demo/helpers/const_data.dart';
import 'package:news_app_flutter_demo/helpers/urlLauncher.dart';
import 'package:provider/provider.dart';

import '../providers/news.dart';

class LikedNewsItem extends StatelessWidget {
  final String headline;
  final String source;
  final String webUrl;
  final String imageUrl;

  LikedNewsItem(
      {required this.headline,
      required this.source,
      required this.webUrl,
      required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        UrlLauncher.launchUrlLink(webUrl);
      },
      child: Card(
        child: ListTile(
          leading: Container(
            width: 100,
            height: 100,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
          title: Text(
            headline,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            source,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          trailing: IconButton(
            icon: Icon(
              Icons.bookmark_remove_rounded,
              color: Colors.red,
            ),
            onPressed: () {
              Provider.of<News>(context, listen: false).removeLikedNews(webUrl);
              Fluttertoast.showToast(
                msg: 'Removed from liked news',
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: redViettel,
                textColor: Colors.white,
                fontSize: 16.0,
              );
            },
          ),
        ),
      ),
    );
  }
}
