import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/news.dart';
import './article_item.dart';

class Home extends ConsumerStatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> with TickerProviderStateMixin {
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
  void dispose() {
    _scrollController.dispose();
    _animController.dispose();
    _animation.removeListener(() {});
    super.dispose();
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
        : Stack(
            children: [
              Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10,
                  ),
                  child: RefreshIndicator(
                    color: Colors.red,
                    onRefresh: () => _refreshNews(context),
                    child: ListView.builder(
                      controller: _scrollController,
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
                  )),
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
          );
  }

  Future<void> _refreshNews(BuildContext context) async {
    await newsNoti.getTopNews();
    setState(() {});
  }
}

typedef ReloadCallback = void Function(BuildContext context);
