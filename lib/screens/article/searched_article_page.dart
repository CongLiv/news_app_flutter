import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_app_flutter_demo/helpers/const_data.dart';
import 'package:news_app_flutter_demo/widgets/title_name.dart';
import '../../widgets/searched_article.dart';
import '../../providers/news.dart';

class SearchedArticleScreen extends ConsumerStatefulWidget {
  final String searchField;
  SearchedArticleScreen({required this.searchField});
  @override
  _SearchedArticleScreenState createState() => _SearchedArticleScreenState();
}

class _SearchedArticleScreenState extends ConsumerState<SearchedArticleScreen> {
  bool _isInit = true;
  var _isLoading = false;

  final newsPro = ProviderContainer().read(newsProvider);

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

    newsPro.getSearchedNews(widget.searchField).then((_) {
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
              child: ListView.builder(
                itemCount: newsPro.searchedNews.length,
                itemBuilder: (ctx, index) {
                  return SearchedArticle(
                    headline: newsPro.searchedNews[index].headline,
                    source: newsPro.searchedNews[index].source,
                    webUrl: newsPro.searchedNews[index].webUrl,
                    date: newsPro.searchedNews[index].date,
                    imageUrl: newsPro.searchedNews[index].imageUrl,
                  );
                },
              ),
            ),
    );
  }
}
