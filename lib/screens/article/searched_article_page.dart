import 'package:flutter/material.dart';
import 'package:news_app_flutter_demo/helpers/const_data.dart';
import 'package:news_app_flutter_demo/widgets/title_name.dart';
import 'package:provider/provider.dart';

import '../../widgets/searched_article.dart';
import '../../providers/news.dart';

class SearchedArticleScreen extends StatefulWidget {
  final String searchField;
  SearchedArticleScreen({required this.searchField});
  @override
  _SearchedArticleScreenState createState() => _SearchedArticleScreenState();
}

class _SearchedArticleScreenState extends State<SearchedArticleScreen> {
  bool _isInit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      _performSearch();
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void _performSearch() {
    setState(() {
      _isLoading = true;
    });
    Provider.of<News>(context, listen: false)
        .getSearchedNews(widget.searchField)
        .then((_) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: redViettel),
        backgroundColor: Theme.of(context).colorScheme.secondary,
        elevation: 0,
        centerTitle: true,
        title: TitleName(text: appNameLogo)
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(redViettel),
              ),
            )
          : Container(
              child: Consumer<News>(
                builder: (ctx, news, child) => ListView.builder(
                  itemCount: news.searchedNews.length,
                  itemBuilder: (ctx, index) {
                    return SearchedArticle(
                      headline: news.searchedNews[index].headline,
                      source: news.searchedNews[index].source,
                      webUrl: news.searchedNews[index].webUrl,
                      date: news.searchedNews[index].date,
                      imageUrl: news.searchedNews[index].imageUrl,
                    );
                  },
                ),
              ),
            ),
    );
  }
}
