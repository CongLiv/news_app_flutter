import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:news_app_flutter_demo/helpers/const_data.dart';
import 'package:news_app_flutter_demo/widgets/title_name.dart';
import 'package:transparent_image/transparent_image.dart';
import '../helpers/share_article.dart';
import '../helpers/urlLauncher.dart';

class ArticlePage extends StatelessWidget {
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
            onPressed: () => ShareArticle.shareArticle(webUrl),
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(imageUrl),
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
                    headline,
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
                    child: FadeInImage.memoryNetwork(
                      placeholder: kTransparentImage,
                      image: imageUrl,
                      fadeInDuration: const Duration(milliseconds: 100),
                      fadeInCurve: Curves.easeIn,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text('Published on : $date',
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
                  Text(description,
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
                  Text('Source :  $source',
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
                        onTap: () => UrlLauncher.launchUrlLink(webUrl),
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
                            // TODO: implement bookmark
                          },
                          child: Icon(
                            Icons.bookmark_add_outlined,
                            color: redViettel,
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
}
