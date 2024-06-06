import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_app_flutter_demo/helpers/const_data.dart';
import '../../providers/news.dart';
import '../../widgets/article_item.dart';

class CategoryNewsScreen extends ConsumerStatefulWidget {
  final String categoryName;

  CategoryNewsScreen({required this.categoryName});

  @override
  _CategoryNewsScreenState createState() => _CategoryNewsScreenState();
}

class _CategoryNewsScreenState extends ConsumerState<CategoryNewsScreen> {
  bool _isInit = true;
  var _isLoading = false;

  final newsPro = ProviderContainer().read(newsProvider);
  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      // Provider.of<News>(context)
      //     .getCategoriesNews(widget.categoryName)
      //     .then((_) {
      //   setState(() {
      //     _isLoading = false;
      //   });
      // });
      newsPro.getCategoriesNews(widget.categoryName).then((_) {
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
            // : Consumer<News>(
            //     builder: (ctx, news, child) => RefreshIndicator(
            //       color: redViettel,
            //       onRefresh: () => _refreshNews(context),
            //       child: ListView.builder(
            //         itemCount: news.categoryNews.length,
            //         itemBuilder: (ctx, index) => ArticleItem(
            //           headline: news.categoryNews[index].headline,
            //           description: news.categoryNews[index].description,
            //           source: news.categoryNews[index].source,
            //           webUrl: news.categoryNews[index].webUrl,
            //           imageUrl: news.categoryNews[index].imageUrl,
            //           date: news.categoryNews[index].date,
            //         ),
            //       ),
            //     ),
            //   ),
            : RefreshIndicator(
                color: redViettel,
                onRefresh: () => _refreshNews(context),
                child: ListView.builder(
                  itemCount: newsPro.categoryNews.length,
                  itemBuilder: (ctx, index) => ArticleItem(
                    headline: newsPro.categoryNews[index].headline,
                    description: newsPro.categoryNews[index].description,
                    source: newsPro.categoryNews[index].source,
                    webUrl: newsPro.categoryNews[index].webUrl,
                    imageUrl: newsPro.categoryNews[index].imageUrl,
                    date: newsPro.categoryNews[index].date,
                  ),
                ),

              ),
      ),
    );
  }

  Future<void> _refreshNews(BuildContext context) async {
    // await Provider.of<News>(context, listen: false)
    //     .getCategoriesNews(widget.categoryName);

    await newsPro.getCategoriesNews(widget.categoryName);
    setState(() {});

  }
}
