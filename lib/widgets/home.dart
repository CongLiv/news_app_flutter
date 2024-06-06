import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/news.dart';
import './article_item.dart';

class Home extends ConsumerStatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  bool _isInit = true;
  var _isLoading = false;

  final newsPro = ProviderContainer().read(newsProvider);

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });

      newsPro.getTopNews().then((_) {
        setState(() {
          _isLoading = false;
        });
      });

    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
            ),
          )
        : Container(
            padding: EdgeInsets.symmetric(
              horizontal: 10,
            ),
            // list of test news
            // child: Consumer<News>(
            //   builder: (ctx, news, child) => RefreshIndicator(
            //     color: Colors.red,
            //     onRefresh: () => _refreshNews(context),
            //     child: ListView.builder(
            //       itemCount: news.topNews.length,
            //       itemBuilder: (ctx, index) => ArticleItem(
            //         headline: news.topNews[index].headline,
            //         description: news.topNews[index].description,
            //         source: news.topNews[index].source,
            //         webUrl: news.topNews[index].webUrl,
            //         imageUrl: news.topNews[index].imageUrl,
            //         date: news.topNews[index].date,
            //       ),
            //     ),
            //   ),
            // ),

            child: RefreshIndicator(
              color: Colors.red,
              onRefresh: () => _refreshNews(context),
              child: ListView.builder(
                itemCount: newsPro.topNews.length,
                itemBuilder: (ctx, index) => ArticleItem(
                  headline: newsPro.topNews[index].headline,
                  description: newsPro.topNews[index].description,
                  source: newsPro.topNews[index].source,
                  webUrl: newsPro.topNews[index].webUrl,
                  imageUrl: newsPro.topNews[index].imageUrl,
                  date: newsPro.topNews[index].date,
                ),
              ),
            )
          );
  }

  Future<void> _refreshNews(BuildContext context) async {
    await newsPro.getTopNews();
    setState(() {});
  }
}

typedef ReloadCallback = void Function(BuildContext context);
