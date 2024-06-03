import 'package:flutter/material.dart';
import 'package:news_app_flutter_demo/widgets/liked_news_item.dart';
import '../helpers/const_data.dart';
import '../widgets/title_name.dart';

class PersonalPage extends StatelessWidget {
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
              Icons.logout_rounded,
            ),
            onPressed: () {
              // TODO: implement logout
            },
          ),
        ],
      ),
      body: Center(
        // divide the screen into 2 parts, profile picture and personal news liked
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 20, bottom: 20),
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: Image.asset('assets/images/profile.jpg').image,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              // personal news liked
              Container(
                child: Text(
                  'Person Name',
                  style: TextStyle(
                    fontSize: 15,
                    fontFamily: 'FS Magistral',
                  ),
                ),
                margin: EdgeInsets.only(bottom: 20),
              ),
              Divider(
                color: redViettel,
                thickness: .5,
                indent: 8,
                endIndent: 8,
              ),
              Container(
                child: Text(
                  'Liked News',
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'FS PFBeauSansPro',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                margin: EdgeInsets.only(top: .5, bottom: 10),
              ),

              Expanded(
                child: ListView.builder(
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return LikedNewsItem(
                      headline: 'headline',
                      source: 'source',
                      webUrl: 'webUrl',
                      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/0/0e/Nytimes_hq.jpg',
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
