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
      newsNoti.getCategoriesNews(widget.categoryName).then((_) {
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
            : RefreshIndicator(
                color: redViettel,
                onRefresh: () => _refreshNews(context),
                child: ListView.builder(
                  itemCount: newsData.categoryNews.length,
                  itemBuilder: (ctx, index) => ArticleItem(
                    headline: newsData.categoryNews[index].headline,
                    description: newsData.categoryNews[index].description,
                    source: newsData.categoryNews[index].source,
                    webUrl: newsData.categoryNews[index].webUrl,
                    imageUrl: newsData.categoryNews[index].imageUrl,
                    date: newsData.categoryNews[index].date,
                  ),
                ),
              ),
      ),
    );
  }

  Future<void> _refreshNews(BuildContext context) async {
    await newsNoti.getCategoriesNews(widget.categoryName);
    setState(() {});

  }
}
