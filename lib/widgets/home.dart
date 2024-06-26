import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/news.dart';
import './article_item.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _isInit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<News>(context).getTopNews().then((_) {
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
            child: Consumer<News>(
              builder: (ctx, news, child) => RefreshIndicator(
                color: Colors.red,
                onRefresh: () => _refreshNews(context),
                child: ListView.builder(
                  itemCount: news.topNews.length,
                  itemBuilder: (ctx, index) => ArticleItem(
                    headline: news.topNews[index].headline,
                    description: news.topNews[index].description,
                    source: news.topNews[index].source,
                    webUrl: news.topNews[index].webUrl,
                    imageUrl: news.topNews[index].imageUrl,
                    date: news.topNews[index].date,
                  ),
                ),
              ),
            ),
          );
  }

  Future<void> _refreshNews(BuildContext context) async {
    await Provider.of<News>(context, listen: false).getTopNews();
    setState(() {});
  }
}

typedef ReloadCallback = void Function(BuildContext context);
