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

class _SearchedArticleScreenState extends ConsumerState<SearchedArticleScreen>
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

    _animation = Tween<double>(begin: -60.0, end: 30.0).animate(
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
      _performSearch();
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void _performSearch() {
    setState(() {
      _isLoading = true;
    });
    newsNoti.getSearchedNews(widget.searchField).then((_) {
      setState(() {
        _isLoading = false;
      });
    });
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
          iconTheme: IconThemeData(color: redViettel),
          backgroundColor: Theme.of(context).colorScheme.secondary,
          elevation: 0,
          centerTitle: true,
          title: TitleName(text: appNameLogo)),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(redViettel),
              ),
            )
          : Stack(
              children: [
                if (newsData.searchedNews.isNotEmpty)
                Container(
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: newsData.searchedNews.length,
                    itemBuilder: (ctx, index) {
                      return SearchedArticle(
                        headline: newsData.searchedNews[index].headline,
                        source: newsData.searchedNews[index].source,
                        webUrl: newsData.searchedNews[index].webUrl,
                        date: newsData.searchedNews[index].date,
                        imageUrl: newsData.searchedNews[index].imageUrl,
                      );
                    },
                  ),
                )
                else
                  Center(
                    // text and button refresh
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'No news available',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'FS PFBeauSansPro',
                            color: Colors.grey[600],
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () => {
                            _refreshNews(context),
                          },
                          style: ButtonStyle(
                            backgroundColor:
                            WidgetStateProperty.all(redViettel),
                          ),
                          child: Text('Refresh',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'FS PFBeauSansPro',
                                color: Colors.white,
                              )),
                        ),
                      ],
                    ),
                  ),
                AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return Positioned(
                      right: _animation.value,
                      bottom: 45,
                      child: Opacity(
                        opacity:
                            _animation.value > 0 ? _animation.value / 30.0 : 0,
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
    );
  }

  Future<void> _refreshNews(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });
    await newsNoti.getSearchedNews(widget.searchField).then((_) {
      setState(() {
        _isLoading = false;
      });
    });
  }
}
