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

      newsNoti.getTopNews().then((_) {
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
    final newsData = ref.watch(newsProvider);
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
            child: RefreshIndicator(
              color: Colors.red,
              onRefresh: () => _refreshNews(context),
              child: ListView.builder(
                itemCount: newsData.topNews.length,
                itemBuilder: (ctx, index) => ArticleItem(
                  headline: newsData.topNews[index].headline,
                  description: newsData.topNews[index].description,
                  source: newsData.topNews[index].source,
                  webUrl: newsData.topNews[index].webUrl,
                  imageUrl: newsData.topNews[index].imageUrl,
                  date: newsData.topNews[index].date,
                ),
              ),
            )
          );
  }

  Future<void> _refreshNews(BuildContext context) async {
    await newsNoti.getTopNews();
    setState(() {});
  }
}

typedef ReloadCallback = void Function(BuildContext context);
