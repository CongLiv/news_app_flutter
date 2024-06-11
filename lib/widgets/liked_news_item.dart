import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:news_app_flutter_demo/firebase_tools/firebase_analyst.dart';
import 'package:news_app_flutter_demo/helpers/const_data.dart';
import 'package:news_app_flutter_demo/screens/article/webview_container.dart';
import '../providers/news.dart';

class LikedNewsItem extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final newsNoti = ref.watch(newsProvider.notifier);
    return GestureDetector(
      onTap: () async {
        await FirebaseAnalyst.logReadNewsEvent(webUrl);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WebviewContainer(
                webUrl: webUrl,
                headline: headline,
                source: source,
                imageUrl: imageUrl,
                description: headline
            ),
          ),
        ).then((_) => newsNoti.getLikedNews());
      },
      child: Card(
        child: ListTile(
          leading: Container(
            width: 100,
            height: 100,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) => Center(
                  child: CircularProgressIndicator(),
                ),
                errorWidget: (context, url, error) => Icon(Icons.error),
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
              newsNoti.removeLikedNews(webUrl);
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
