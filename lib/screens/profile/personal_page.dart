import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:news_app_flutter_demo/widgets/liked_news_item.dart';
import 'package:provider/provider.dart';
import '../../helpers/const_data.dart';
import '../../providers/news.dart';
import '../../widgets/title_name.dart';

class PersonalPage extends StatefulWidget {
  @override
  _PersonalPageState createState() => _PersonalPageState();
}

class _PersonalPageState extends State<PersonalPage> {
  final _auth = FirebaseAuth.instance;
  String email = '';
  bool _isInit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<News>(context).getLikedNews().then((_) {
        setState(() {
          _isLoading = false;
        });
      });

      email = _auth.currentUser!.email!;
    }
    _isInit = false;
    super.didChangeDependencies();
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
              Icons.logout_rounded,
            ),
            onPressed: () {
              _auth.signOut();
              Fluttertoast.showToast(
                msg: 'Logged out',
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: redViettel,
                textColor: Colors.white,
                fontSize: 16.0,
              );
              Navigator.of(context).pop();
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
                  email,
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

              _isLoading
                  ? Expanded(
                      child: Center(
                        child: CircularProgressIndicator(
                          color: redViettel,
                        ),
                      ),
                    )
                  : Expanded(
                      child: Provider.of<News>(context).likedNews.isEmpty
                          ? Center(
                              child: Text(
                                'You have not liked any news yet.',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontFamily: 'FS PFBeauSansPro',
                                  fontStyle: FontStyle.italic,
                                  color: Colors.grey[600],
                                ),
                              ),
                            )
                          : Consumer<News>(
                              builder: (ctx, news, child) => RefreshIndicator(
                                color: redViettel,
                                onRefresh: () => _refreshLikedNews(context),
                                child: ListView.builder(
                                  itemCount: news.likedNews.length,
                                  itemBuilder: (ctx, index) => LikedNewsItem(
                                    headline: news.likedNews[index].headline,
                                    source: news.likedNews[index].source,
                                    webUrl: news.likedNews[index].webUrl,
                                    imageUrl: news.likedNews[index].imageUrl,
                                  ),
                                ),
                              ),
                            ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _refreshLikedNews(BuildContext context) async {
    await Provider.of<News>(context, listen: false).getLikedNews();
    setState(() {});
  }
}
