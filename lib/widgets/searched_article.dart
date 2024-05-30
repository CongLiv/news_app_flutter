import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_app_flutter_demo/helpers/const_data.dart';
import 'package:transparent_image/transparent_image.dart';
import '../helpers/urlLauncher.dart';

class SearchedArticle extends StatelessWidget {
  final String headline;
  final String source;
  final String webUrl;
  final String date;
  final String imageUrl;

  SearchedArticle(
      {required this.headline,
      required this.source,
      required this.webUrl,
      required this.date,
      required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => UrlLauncher.launchUrlLink(webUrl),
      child: Container(
        margin: EdgeInsets.fromLTRB(10, 2, 10, 8),
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            IconButton(
                icon: Icon(
                  Icons.launch,
                  color: redViettel,
                ),
                onPressed: () => UrlLauncher.launchUrlLink(webUrl)),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                Text(
                  headline,
                  style: TextStyle(
                    fontFamily: 'FS PFBeauSansPro',
                    fontSize: 16,
                    letterSpacing: 1,
                    color: Colors.black,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      date,
                      style: TextStyle(
                        fontFamily: 'FS PFBeauSansPro',
                        fontSize: 12,
                        letterSpacing: .5,
                        color: Colors.black54,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    Text(
                      source,
                      style: TextStyle(
                        fontFamily: 'FS PFBeauSansPro',
                        fontSize: 12,
                        letterSpacing: .5,
                        color: Colors.black54,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
