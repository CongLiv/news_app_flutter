import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:news_app_flutter_demo/firebase_tools/firebase_analyst.dart';
import 'package:news_app_flutter_demo/helpers/const_data.dart';
import 'package:news_app_flutter_demo/firebase_tools/firebase_account.dart';
import 'package:news_app_flutter_demo/widgets/title_name.dart';
import '../../helpers/share_article.dart';
import 'webview_container.dart';

class ArticlePage extends StatefulWidget {
  final String headline;
  final String description;
  final String source;
  final String webUrl;
  final String imageUrl;
  final String date;

  ArticlePage({
    required this.headline,
    required this.description,
    required this.source,
    required this.webUrl,
    required this.imageUrl,
    required this.date,
  });

  @override
  State<ArticlePage> createState() => _ArticlePageState();
}

class _ArticlePageState extends State<ArticlePage> {
  final _firestore = FirebaseFirestore.instance;
  bool isMarked = false;

  @override
  void initState() {
    super.initState();

    // check if article is already marked
    if (FirebaseAccount.isSignedIn()) {
      checkArticleMarked().then((value) {
        setState(() {
          isMarked = value;
        });
      });
    }
  }

  Future<bool> checkArticleMarked() async {
    final value = await _firestore
        .collection('news_mark')
        .doc(FirebaseAccount.getEmail())
        .collection('news')
        .where('webUrl', isEqualTo: widget.webUrl)
        .get();

    if (value.docs.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: redViettel),
        backgroundColor: Theme.of(context).colorScheme.secondary,
        elevation: 0,
        centerTitle: true,
        title: TitleName(text: appNameLogo),
        actions: [
          IconButton(
            icon: Icon(
              Icons.share,
            ),
            onPressed: () => ShareArticle.shareArticle(widget.webUrl),
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: CachedNetworkImageProvider(widget.imageUrl),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.center,
                  colors: [
                    Theme.of(context).colorScheme.secondary,
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.only(top: 150),
              padding: EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 30,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.headline,
                    style: TextStyle(
                        fontFamily: 'FS Magistral',
                        fontSize: 16,
                        letterSpacing: 1,
                        color: Theme.of(context).colorScheme.onSurface,
                        fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CachedNetworkImage(
                      imageUrl: widget.imageUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Center(
                        child: CircularProgressIndicator(),
                      ),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text('Published on : ${widget.date}',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontFamily: 'FS PFBeauSansPro',
                        color: Theme.of(context).colorScheme.onSecondary,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 1,
                      )),
                  SizedBox(
                    height: 8,
                  ),
                  Text(widget.description,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontFamily: 'FS PFBeauSansPro',
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1,
                      )),
                  SizedBox(
                    height: 8,
                  ),
                  Text('Source :  ${widget.source}',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontFamily: 'FS PFBeauSansPro',
                        color: Theme.of(context).colorScheme.onSecondary,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1,
                      )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () async => {
                          await FirebaseAnalyst.logReadNewsEvent(widget.webUrl),
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WebviewContainer(
                                  webUrl: widget.webUrl,
                                  headline: widget.headline,
                                  source: widget.source,
                                  imageUrl: widget.imageUrl,
                                  description: widget.description),
                            ),
                          ).then((_) => {
                                if (FirebaseAccount.isSignedIn())
                                  {
                                    checkArticleMarked().then((value) {
                                      setState(() {
                                        isMarked = value;
                                      });
                                    })
                                  }
                              }),
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                          margin: EdgeInsets.only(top: 20),
                          decoration: BoxDecoration(
                            color: redViettel,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Text('Read Article',
                              style: TextStyle(
                                fontFamily: 'FS Magistral',
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 1,
                              )),
                        ),
                      ),
                      // bookmark button
                      Container(
                        margin: EdgeInsets.only(top: 20, right: 20),
                        child: GestureDetector(
                          onTap: () {
                            !FirebaseAccount.isSignedIn()
                                ? notLoggedIn()
                                : isMarked
                                    ? removeArticle()
                                    : addArticle();
                          },
                          child: Icon(
                            isMarked
                                ? Icons.bookmark
                                : Icons.bookmark_add_outlined,
                            color: isMarked ? redViettel : Colors.grey,
                            size: 35,
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  // add article to firestore
  Future<void> addArticle() async {
    try {
      _firestore
          .collection('news_mark')
          .doc(FirebaseAccount.getEmail())
          .collection('news')
          .add({
        'headline': widget.headline,
        'description': widget.description,
        'source': widget.source,
        'webUrl': widget.webUrl,
        'imageUrl': widget.imageUrl,
      });
      await FirebaseAnalyst.logMarkFavoriteEvent(widget.webUrl);
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Error: $e',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
    Fluttertoast.showToast(
      msg: 'Article Marked',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: redViettel,
      textColor: Colors.white,
      fontSize: 16.0,
    );
    setState(() {
      isMarked = true;
    });
  }

  // remove article from firestore
  void removeArticle() {
    try {
      _firestore
          .collection('news_mark')
          .doc(FirebaseAccount.getEmail())
          .collection('news')
          .where('webUrl', isEqualTo: widget.webUrl)
          .get()
          .then((value) {
        value.docs.forEach((element) {
          element.reference.delete();
        });
      });
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Error: $e',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: redViettel,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
    Fluttertoast.showToast(
      msg: 'Article Unmarked',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: redViettel,
      textColor: Colors.white,
      fontSize: 16.0,
    );
    setState(() {
      isMarked = false;
    });
  }

  void notLoggedIn() {
    Fluttertoast.showToast(
      msg: 'Please login to mark articles',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: redViettel,
      textColor: Colors.white,
      fontSize: 16.0,
    );
    setState(() {
      isMarked = false;
    });
  }
}
