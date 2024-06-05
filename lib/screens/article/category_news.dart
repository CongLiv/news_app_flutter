import 'package:flutter/material.dart';
import 'package:news_app_flutter_demo/helpers/const_data.dart';
import 'package:provider/provider.dart';

import '../../providers/news.dart';
import '../../widgets/article_item.dart';

class CategoryNewsScreen extends StatefulWidget {
  final String categoryName;

  CategoryNewsScreen({required this.categoryName});

  @override
  _CategoryNewsScreenState createState() => _CategoryNewsScreenState();
}

class _CategoryNewsScreenState extends State<CategoryNewsScreen> {
  bool _isInit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<News>(context)
          .getCategoriesNews(widget.categoryName)
          .then((_) {
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
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: IconThemeData(color: redViettel),
        backgroundColor: Theme.of(context).colorScheme.secondary,
        elevation: 0,
        title: Text(widget.categoryName.toUpperCase(),
            style: TextStyle(
              fontFamily: 'FS PFBeauSansPro',
              fontSize: 21,
              fontWeight: FontWeight.w900,
              letterSpacing: 2,
              color: redViettel,
            )),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: _isLoading
            ? Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(redViettel),
                ),
              )
            : Consumer<News>(
                builder: (ctx, news, child) => RefreshIndicator(
                  color: redViettel,
                  onRefresh: () => _refreshNews(context),
                  child: ListView.builder(
                    itemCount: news.categoryNews.length,
                    itemBuilder: (ctx, index) => ArticleItem(
                      headline: news.categoryNews[index].headline,
                      description: news.categoryNews[index].description,
                      source: news.categoryNews[index].source,
                      webUrl: news.categoryNews[index].webUrl,
                      imageUrl: news.categoryNews[index].imageUrl,
                      date: news.categoryNews[index].date,
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  Future<void> _refreshNews(BuildContext context) async {
    await Provider.of<News>(context, listen: false)
        .getCategoriesNews(widget.categoryName);
    setState(() {});

  }
}
