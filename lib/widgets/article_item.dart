import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

import '../screens/article/article_page.dart';

class ArticleItem extends StatelessWidget {
  final String headline;
  final String description;
  final String source;
  final String webUrl;
  final String imageUrl;
  final String date;

  ArticleItem({
    required this.headline,
    required this.description,
    required this.source,
    required this.webUrl,
    required this.imageUrl,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (ctx) => ArticlePage(
              headline: headline,
              description: description,
              source: source,
              imageUrl: imageUrl,
              webUrl: webUrl,
              date: date,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          border: Border.all(color: Theme.of(context).colorScheme.secondary),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 2,
              offset: Offset(0, 1), // changes position of shadow
            ),
          ],
        ),
        margin: EdgeInsets.only(
          bottom: 8,
        ),
        padding: EdgeInsets.all(5),
        width: double.infinity,
        child: Column(
          children: [
            Container(
                margin: EdgeInsets.only(bottom: 4),
                height: 180,
                width: double.infinity,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: FadeInImage.memoryNetwork(
                    placeholder: kTransparentImage,
                    image: imageUrl,
                    fadeInDuration: const Duration(milliseconds: 100),
                    fadeInCurve: Curves.easeIn,
                    fit: BoxFit.cover,
                  ),
                )),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    headline,
                    style: TextStyle(
                      fontFamily: 'FS PFBeauSansPro',
                      fontSize: 18,
                      letterSpacing: 1,
                      color: Theme.of(context).colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    padding: EdgeInsets.symmetric(horizontal: 2),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            source,
                            softWrap: true,
                            style: TextStyle(
                              fontFamily: 'FS PFBeauSansPro',
                              fontSize: 14,
                              letterSpacing: .75,
                              color: Theme.of(context).colorScheme.onSurface,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        // Spacer(),
                        Expanded(
                          flex: 1,
                          child: Text(
                            date,
                            softWrap: true,
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontFamily: 'FS PFBeauSansPro',
                              fontSize: 12,
                              letterSpacing: .75,
                              color: Theme.of(context).colorScheme.onSurface,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
