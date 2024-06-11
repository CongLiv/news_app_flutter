import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:news_app_flutter_demo/firebase_tools/firebase_analyst.dart';
import 'package:news_app_flutter_demo/helpers/toast_log.dart';
import 'package:news_app_flutter_demo/helpers/urlLauncher.dart';
import 'package:news_app_flutter_demo/widgets/title_name.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../firebase_tools/firestore_articles.dart';
import '../../helpers/const_data.dart';
import '../../firebase_tools/firebase_account.dart';
import '../../helpers/share_article.dart';

class WebviewContainer extends StatefulWidget {
  final String headline;
  final String source;
  final String webUrl;
  final String imageUrl;
  final String description;

  WebviewContainer(
      {super.key,
      required this.webUrl,
      required this.headline,
      required this.source,
      required this.imageUrl,
      required this.description});

  @override
  _WebviewContainerState createState() => _WebviewContainerState();
}

class _WebviewContainerState extends State<WebviewContainer> {
  late final WebViewController _controller;
  bool isMarked = false;
  bool isLoading = true;
  bool isSet = false;

  void setLoad(bool load) {
    setState(() {
      isLoading = load;
      isSet = true;
    });
  }

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
        onProgress: (int progress) {
          if (progress > 70 && !isSet) {
            setLoad(false);
          }
        },
      ))
      ..loadRequest(Uri.parse(widget.webUrl));

    // check if article is already marked
    if (FirebaseAccount.isSignedIn()) {
      FireStoreArticles.checkArticleMarked(widget.webUrl).then((value) {
        setState(() {
          isMarked = value;
        });
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
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
          PopupMenuButton(
            onSelected: (value) {
              if (value == 'Reload') {
                setState(() {
                  isLoading = true;
                  isSet = false;
                });
                _controller.reload();
              } else if (value == 'Open') {
                UrlLauncher.launchUrlLink(widget.webUrl);
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                    child: Text('Reload',
                        style: TextStyle(fontFamily: 'FS PFBeauSansPro')),
                    value: 'Reload'),
                PopupMenuItem(
                  child: Text(
                    'Open in Browser',
                    style: TextStyle(fontFamily: 'FS PFBeauSansPro'),
                  ),
                  value: 'Open',
                ),
              ];
            },
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _controller.reload();
        },
        child: Stack(
          children: [
            WebViewWidget(
              controller: _controller,
            ),
            if (isLoading)
              Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(redViettel),
                ),
              ),
            Positioned(
              right: 30,
              bottom: 45,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: GestureDetector(
                  child: CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    radius: 30,
                    child: IconButton(
                      icon: Icon(
                        isMarked ? Icons.bookmark : Icons.bookmark_add_outlined,
                        color: isMarked ? redViettel : Colors.grey,
                        size: 29,
                      ),
                      onPressed: () {
                        !FirebaseAccount.isSignedIn()
                            ? notLoggedIn()
                            : isMarked
                                ? removeArticle()
                                : addArticle();
                      },

                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void addArticle() {
    FireStoreArticles.addArticle(
      headline: widget.headline,
      description: widget.description,
      source: widget.source,
      webUrl: widget.webUrl,
      imageUrl: widget.imageUrl,
      onSuccess: () {
        FirebaseAnalyst.logMarkFavoriteEvent(widget.webUrl);
        ToastLog.show('Article Marked');
        setState(() {
          isMarked = true;
        });
      },
      onError: (error) {
        ToastLog.show('Error: $error');
      },
    );
  }

  void removeArticle() {
    FireStoreArticles.removeArticle(
      webUrl: widget.webUrl,
      onSuccess: () {
        ToastLog.show('Article Unmarked');
        setState(() {
          isMarked = false;
        });
      },
      onError: (error) {
        ToastLog.show('Error: $error');
      },
    );
  }

  void notLoggedIn() {
    ToastLog.show('Please login to mark articles');
    setState(() {
      isMarked = false;
    });
  }
}
