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

class _CategoryNewsScreenState extends ConsumerState<CategoryNewsScreen>
    with TickerProviderStateMixin {
  bool _isInit = true;
  var _isLoading = false;

  bool _showBackToTop = false;
  late final ScrollController _scrollController;

  late AnimationController _animController;
  late Animation<double> _animation;

  late final newsNoti;

  @override
  void initState() {
    super.initState();
    newsNoti = ref.read(newsProvider.notifier);

    _animController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );

    _animation = Tween<double>(begin: -60.0, end: 25.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );

    _animation.addListener(() {
      setState(() {});
    });

    _scrollController = ScrollController()
      ..addListener(() {
        if (_scrollController.offset >= 400) {
          if (!_showBackToTop) {
            setState(() {
              _showBackToTop = true;
            });
            _animController.forward();
          }
        } else {
          if (_showBackToTop) {
            setState(() {
              _showBackToTop = false;
            });
          }
          _animController.reverse();
        }
      });
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
  void dispose() {
    _scrollController.dispose();
    _animController.dispose();
    _animation.removeListener(() {});
    super.dispose();

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
            : Stack(
                children: [
                  RefreshIndicator(
                    color: redViettel,
                    onRefresh: () => _refreshNews(context),
                    child: ListView.builder(
                      controller: _scrollController,
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
                  AnimatedBuilder(
                    animation: _animation,
                    builder: (context, child) {
                      return Positioned(
                        right: _animation.value,
                        bottom: 45,
                        child: Opacity(
                          opacity: _animation.value > 0
                              ? _animation.value / 25.0
                              : 0,
                          child: SizedBox(
                            height: 55,
                            width: 55,
                            child: FloatingActionButton(
                              backgroundColor:
                                  Theme.of(context).colorScheme.surface,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(90),
                              ),
                              onPressed: () {
                                _scrollController.animateTo(
                                  0,
                                  duration: Duration(milliseconds: 800),
                                  curve: Curves.easeInOut,
                                );
                              },
                              child: Icon(
                                Icons.arrow_upward,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
      ),
    );
  }

  Future<void> _refreshNews(BuildContext context) async {
    await newsNoti.getCategoriesNews(widget.categoryName);
    setState(() {});
  }
}
