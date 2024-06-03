import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
        // Provider.of<News>(context, listen: false).launchUrlLink(webUrl);
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
              // Provider.of<News>(context, listen: false).removeLikedNews(webUrl);
            },
          ),
        ),
      ),
    );
  }
}
