import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_app_flutter_demo/helpers/const_data.dart';
import '../providers/news.dart';
import './article_item.dart';

class Home extends ConsumerStatefulWidget {
  static Future<void> resetScroll() async {
    _HomeState.resetScroll();
  }

  static void reloadScroll() {
    _HomeState.reloadScroll();
  }

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> with TickerProviderStateMixin {
  bool _isInit = true;
  var _isLoading = false;

  bool _showBackToTop = false;
  static late final ScrollController homeScrollController;
  static late final AnimationController homeAnimController;
  static late final Animation<double> homeAnimation;
  static double lastScrollOffset = 0;

  late final newsNoti;

  @override
  void initState() {
    super.initState();

    newsNoti = ref.read(newsProvider.notifier);

    homeAnimController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );

    homeAnimation = Tween<double>(begin: -60.0, end: 30.0).animate(
      CurvedAnimation(parent: homeAnimController, curve: Curves.easeInOut),
    );

    homeAnimation.addListener(() {
      setState(() {});
    });

    homeScrollController = ScrollController()
      ..addListener(() {
        if (homeScrollController.offset >= 400) {
          if (!_showBackToTop) {
            setState(() {
              _showBackToTop = true;
            });
            homeAnimController.forward();
          }
        } else {
          if (_showBackToTop) {
            setState(() {
              _showBackToTop = false;
            });
          }
          homeAnimController.reverse();
        }
      });
  }

  @override
  void dispose() {
    homeScrollController.dispose();
    homeAnimController.dispose();
    homeAnimation.removeListener(() {});
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

  static void resetScroll() {
    if (homeScrollController.hasClients == false) {
      return;
    }
    lastScrollOffset = homeScrollController.offset;
    homeAnimController.reset();
    homeScrollController.animateTo(
      0,
      duration: Duration(milliseconds: 800),
      curve: Curves.easeInOut,
    );
  }

  static void reloadScroll() {
    // if scroll not attached to any widget
    if (homeScrollController.hasClients == false) {
      return;
    }
    // jump to last scroll offset
    homeScrollController.jumpTo(lastScrollOffset);
    if (homeScrollController.offset >= 400) {
      homeAnimController.forward();
    } else {
      homeAnimController.reverse();
    }
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
              if (newsData.topNews.isNotEmpty)
                Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10,
                    ),
                    child: RefreshIndicator(
                      color: Colors.red,
                      onRefresh: () => _refreshNews(context),
                      child: ListView.builder(
                        controller: homeScrollController,
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
                    ))
              else
                Center(
                  // text and button refresh
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'No news available!',
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
                          backgroundColor: WidgetStateProperty.all(redViettel),
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
                animation: homeAnimation,
                builder: (context, child) {
                  return Positioned(
                    right: homeAnimation.value,
                    bottom: 45,
                    child: Opacity(
                      opacity: homeAnimation.value > 0
                          ? homeAnimation.value / 30.0
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
                            homeScrollController.animateTo(
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
    setState(() {
      _isLoading = true;
    });
    newsNoti.getTopNews().then((_) {
      setState(() {
        _isLoading = false;
      });
    });
  }
}

typedef ReloadCallback = void Function(BuildContext context);
