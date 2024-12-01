import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:news_app_flutter_demo/firebase_tools/firebase_analyst.dart';
import 'package:news_app_flutter_demo/firebase_tools/firestore_articles.dart';
import 'package:news_app_flutter_demo/helpers/const_data.dart';
import 'package:news_app_flutter_demo/firebase_tools/firebase_account.dart';
import 'package:news_app_flutter_demo/helpers/toast_log.dart';
import 'package:news_app_flutter_demo/providers/categories.dart';
import 'package:news_app_flutter_demo/providers/news.dart';
import 'package:news_app_flutter_demo/providers/recommender.dart';
import 'package:news_app_flutter_demo/widgets/title_name.dart';
import '../../helpers/share_article.dart';
import '../../models/article.dart';
import 'webview_container.dart';


class ArticlesPageView extends ConsumerWidget {
  final int initialIndex;
  final bool isHomePage;

  const ArticlesPageView({
    super.key,
    required this.initialIndex,
    this.isHomePage = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<Article> articles = isHomePage ? ref.watch(newsProvider).topNews : ref.watch(newsProvider).categoryNews;
    int currentIndex = initialIndex;
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: redViettel),
        backgroundColor: Theme.of(context).colorScheme.secondary,
        elevation: 0,
        centerTitle: true,
        title: const TitleName(text: appNameLogo),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.share,
            ),
            onPressed: () => ShareArticle.shareArticle(articles[currentIndex].webUrl),
          ),
        ],
      ),
      body: PageView.builder(
        controller: PageController(initialPage: initialIndex),
        itemCount: articles.length,
        onPageChanged: (index) async {
          currentIndex = index;
          if (index > articles.length - 8 && isHomePage) {
            await ref.read(newsProvider.notifier).appendTopNews();
          }
        },
        itemBuilder: (ctx, index) {
          final article = articles[index];
          return ArticlePage(
            headline: article.headline,
            description: article.description,
            source: article.source,
            webUrl: article.webUrl,
            imageUrl: article.imageUrl,
            date: article.date,
          );
        },
      ),
    );
  }
}

class ArticlePage extends ConsumerStatefulWidget {
  final String headline;
  final String description;
  final String source;
  final String webUrl;
  final String imageUrl;
  final String date;

  const ArticlePage({
    super.key,
    required this.headline,
    required this.description,
    required this.source,
    required this.webUrl,
    required this.imageUrl,
    required this.date,
  });

  @override
  ConsumerState<ArticlePage> createState() => _ArticlePageState();
}

class _ArticlePageState extends ConsumerState<ArticlePage> {
  bool isMarked = false;

  @override
  void initState() {
    super.initState();

    // check if article is already marked
    if (FirebaseAccount.isSignedIn()) {
      FireStoreArticles.checkArticleMarked(widget.webUrl).then((value) {
        if (mounted) {
          setState(() {
            isMarked = value;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double topMargin = MediaQuery.of(context).size.height * 0.25;
    bool isShowHint = ref.watch(showHintProvider);
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: CachedNetworkImageProvider(widget.imageUrl),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.center,
                  colors: [
                    Theme.of(context).colorScheme.secondary,
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          LayoutBuilder(builder:
              (BuildContext context, BoxConstraints viewportConstraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: viewportConstraints.maxHeight,
                ),
                child: Container(
                  margin: EdgeInsets.only(top: topMargin),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 30,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.headline,
                        style: TextStyle(
                            fontFamily: 'FS Magistral',
                            fontSize: 16,
                            letterSpacing: 1,
                            color: Theme.of(context).colorScheme.onSurface,
                            fontWeight: FontWeight.w600),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: CachedNetworkImage(
                          imageUrl: widget.imageUrl,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => const Center(
                            child: CircularProgressIndicator(),
                          ),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text('Published on : ${widget.date}',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontFamily: 'FS PFBeauSansPro',
                            color: Theme.of(context).colorScheme.onSecondary,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 1,
                          )),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(widget.description,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontFamily: 'FS PFBeauSansPro',
                            color: Theme.of(context).colorScheme.onSurface,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 1,
                          )),
                      const SizedBox(
                        height: 8,
                      ),
                      Text('Source :  ${widget.source}',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontFamily: 'FS PFBeauSansPro',
                            color: Theme.of(context).colorScheme.onSecondary,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 1,
                          )),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () async => {
                              if (FirebaseAccount.isSignedIn())
                                {
                                  ref
                                      .read(recommenderProvider.notifier)
                                      .addLastReadNews(
                                          FirebaseAccount.getEmail(),
                                          widget.headline)
                                },
                              FirebaseAnalyst.logReadNewsEvent(widget.webUrl),
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => WebViewContainer(
                                      webUrl: widget.webUrl,
                                      headline: widget.headline,
                                      source: widget.source,
                                      imageUrl: widget.imageUrl,
                                      description: widget.description),
                                ),
                              ).then((_) => {
                                    if (FirebaseAccount.isSignedIn())
                                      {
                                        FireStoreArticles.checkArticleMarked(
                                                widget.webUrl)
                                            .then((value) {
                                          setState(() {
                                            isMarked = value;
                                          });
                                        })
                                      }
                                  }),
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 12),
                              margin: const EdgeInsets.only(top: 20),
                              decoration: BoxDecoration(
                                color: redViettel,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: const Text('Read Article',
                                  style: TextStyle(
                                    fontFamily: 'FS Magistral',
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 1,
                                  )),
                            ),
                          ),
                          // bookmark button
                          Container(
                            margin: const EdgeInsets.only(top: 20, right: 20),
                            child: GestureDetector(
                              onTap: () {
                                !FirebaseAccount.isSignedIn()
                                    ? notLoggedIn()
                                    : isMarked
                                        ? removeArticle()
                                        : addArticle();
                              },
                              onDoubleTap: null,
                              child: Icon(
                                isMarked
                                    ? Icons.bookmark
                                    : Icons.bookmark_add_outlined,
                                color: isMarked ? redViettel : Colors.grey,
                                size: 35,
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
          if (isShowHint && !FirebaseAccount.isSignedIn())
            GestureDetector(
              onTap: () {
                ref.read(showHintProvider.notifier).state = false;
              },
              onHorizontalDragDown: (details) {
                ref.read(showHintProvider.notifier).state = false;
              },
              child: Container(
                color: Colors.black.withOpacity(0.6),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Lottie.asset(
                        'assets/anims/swipe_anim.json',
                        height: 120,
                      ),
                      const Text(
                        'Swipe to read more news!',
                        style: TextStyle(
                          fontFamily: 'FS Magistral',
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }

  void addArticle() {
    FireStoreArticles.addArticle(
      headline: widget.headline,
      description: widget.description,
      source: widget.source,
      webUrl: widget.webUrl,
      imageUrl: widget.imageUrl,
      onSuccess: () {
        FirebaseAnalyst.logMarkFavoriteEvent(widget.webUrl);
        setState(() {
          isMarked = true;
        });
        ToastLog.show('Article Marked');
      },
      onError: (error) {
        ToastLog.show('Error: $error');
      },
    );
  }

  void removeArticle() {
    FireStoreArticles.removeArticle(
      webUrl: widget.webUrl,
      onSuccess: () {
        setState(() {
          isMarked = false;
        });
        ToastLog.show('Article Unmarked');
      },
      onError: (error) {
        ToastLog.show('Error: $error');
      },
    );
  }

  void notLoggedIn() {
    ToastLog.show('Please login to mark articles');
    setState(() {
      isMarked = false;
    });
  }
}
