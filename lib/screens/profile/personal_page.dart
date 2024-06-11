import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_app_flutter_demo/firebase_tools/firebase_account.dart';
import 'package:news_app_flutter_demo/helpers/toast_log.dart';
import 'package:news_app_flutter_demo/widgets/liked_news_item.dart';
import '../../helpers/const_data.dart';
import '../../providers/news.dart';
import '../../widgets/title_name.dart';

class PersonalPage extends ConsumerStatefulWidget {
  @override
  _PersonalPageState createState() => _PersonalPageState();
}

class _PersonalPageState extends ConsumerState<PersonalPage> {
  String email = '';
  bool _isInit = true;
  var _isLoading = false;

  late final newsNoti;

  @override
  void initState() {
    super.initState();
    newsNoti = ref.read(newsProvider.notifier);
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      newsNoti.getLikedNews().then((_) {
        setState(() {
          _isLoading = false;
        });
      });

      email = FirebaseAccount.getEmail();
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void _handleSignOut() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(redViettel),
          ),
        );
      },
    );

    await FirebaseAccount.signOut(
      onSuccess: () {
        Navigator.of(context).pop();
        ToastLog.show('Logged out');
        Navigator.of(context).pop();
      },
      onError: (e) {
        Navigator.of(context).pop();
        ToastLog.show('Failed to log out');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final newsData = ref.watch(newsProvider);
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
              _handleSignOut();
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
                      child: newsData.likedNews.isEmpty
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
                          : RefreshIndicator(
                              color: redViettel,
                              onRefresh: () => _refreshLikedNews(context),
                              child: ListView.builder(
                                itemCount: newsData.likedNews.length,
                                itemBuilder: (ctx, index) => LikedNewsItem(
                                  headline: newsData.likedNews[index].headline,
                                  source: newsData.likedNews[index].source,
                                  webUrl: newsData.likedNews[index].webUrl,
                                  imageUrl: newsData.likedNews[index].imageUrl,
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
    await newsNoti.getLikedNews();
    setState(() {});
  }
}
