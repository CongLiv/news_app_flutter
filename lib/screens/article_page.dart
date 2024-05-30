import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_app_flutter_demo/helpers/const_data.dart';
import 'package:news_app_flutter_demo/widgets/title_name.dart';
import 'package:transparent_image/transparent_image.dart';
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
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: TitleName(text: appNameLogo),
        actions: [
          IconButton(
            icon: Icon(
              Icons.open_in_browser,
            ),
            onPressed: () => UrlLauncher.launchUrlLink(webUrl),
          ),
        ],
      ),
      body: Stack(
        children: [
          Image.asset(
            'assets/images/searchScreen.jpg',
            width: double.infinity,
          ),
          SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.only(top: 150),
              padding: EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 30,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
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
                        color: Colors.black,
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
                  Text(
                    'Published on : $date',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontFamily: 'FS PFBeauSansPro',
                      color: Colors.black87,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 1,
                    )
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    description,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontFamily: 'FS PFBeauSansPro',
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1,
                    )
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    'Source :  $source',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontFamily: 'FS PFBeauSansPro',
                      color: Colors.black54,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1,
                    )
                  ),
                  GestureDetector(
                    onTap: () => UrlLauncher.launchUrlLink(webUrl),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      margin: EdgeInsets.only(top: 20),
                      decoration: BoxDecoration(
                        color: redViettel,
                      ),
                      child: Text(
                        'Read Article',
                        style: TextStyle(
                          fontFamily: 'FS Magistral',
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1,
                        )
                      ),
                    ),
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
