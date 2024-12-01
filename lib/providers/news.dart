import 'dart:convert';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:dio/dio.dart';
import 'package:news_app_flutter_demo/firebase_tools/firestore_articles.dart';
import 'package:news_app_flutter_demo/helpers/check_connection.dart';
import 'package:news_app_flutter_demo/firebase_tools/firebase_account.dart';
import 'package:news_app_flutter_demo/helpers/toast_log.dart';
import 'package:news_app_flutter_demo/providers/recommender.dart';
import 'package:news_app_flutter_demo/widgets/liked_news_item.dart';
import '../models/article.dart';
import '../models/searchedArticle.dart';

final newsProvider = StateNotifierProvider<News, NewsState>((ref) {
  return News(ref);
});

class NewsState {
  final List<Article> topNews;
  final List<SearchedArticle> searchedNews;
  final List<Article> categoryNews;
  final List<LikedNewsItem> likedNews;
  final bool isNewTimeOpenApp;
  final bool inAppendProgress;

  NewsState({
    required this.topNews,
    required this.searchedNews,
    required this.categoryNews,
    required this.likedNews,
    this.isNewTimeOpenApp = true,
    this.inAppendProgress = false,
  });

  NewsState copyWith({
    List<Article>? topNews,
    List<SearchedArticle>? searchedNews,
    List<Article>? categoryNews,
    List<LikedNewsItem>? likedNews,
    bool? isNewTimeOpenApp,
    bool? inAppendProgress,
  }) {
    return NewsState(
      topNews: topNews ?? this.topNews,
      searchedNews: searchedNews ?? this.searchedNews,
      categoryNews: categoryNews ?? this.categoryNews,
      likedNews: likedNews ?? this.likedNews,
      isNewTimeOpenApp: isNewTimeOpenApp ?? this.isNewTimeOpenApp,
      inAppendProgress: inAppendProgress ?? this.inAppendProgress,
    );
  }
}

class News extends StateNotifier<NewsState> {
  final Ref ref;

  News(this.ref)
      : super(NewsState(
          topNews: [],
          searchedNews: [],
          categoryNews: [],
          likedNews: [],
        ));

  // HELPER FUNCTIONS
  String formatter(String date) {
    DateTime parsedDate = DateTime.parse(date);
    var formattedDate = DateFormat('dd/MM/yyyy').format(parsedDate);
    return formattedDate;
  }

  /// FETCH DATA BY NYT API
  final String nytApiKey = FirebaseRemoteConfig.instance.getString('nytApiKey');
  final nytUrl = "https://api.nytimes.com/svc";

  Future<void> getSearchedNews(String category) async {
    final url =
        '$nytUrl/search/v2/articlesearch.json?q=$category&api-key=$nytApiKey';
    if (!await CheckConnection.isInternet()) {
      ToastLog.show('No internet connection');
      return;
    }
    try {
      var response = await Dio().get(url);
      var jsonResponse;

      if (response.data is String) {
        jsonResponse = json.decode(response.data);
      } else if (response.data is Map<String, dynamic>) {
        jsonResponse = response.data;
      }

      List<SearchedArticle> loadedItems = [];
      List extractedData = jsonResponse['response']['docs'];
      for (var item in extractedData) {
        if (item['abstract'] == null ||
            item['source'] == null ||
            item['pub_date'] == null ||
            item['web_url'] == null) {
          continue;
        }
        String imageUrl;

        // Check if 'multimedia' list is not empty before accessing its elements
        if (item['multimedia'] != null && item['multimedia'].isNotEmpty) {
          imageUrl = 'https://static01.nyt.com/${item['multimedia'][0]['url']}';
        } else {
          if (item['web_url'] != null) {
            imageUrl =
                'https://upload.wikimedia.org/wikipedia/commons/0/0e/Nytimes_hq.jpg';
          } else {
            continue;
          }
        }
        loadedItems.add(SearchedArticle(
          headline: item['abstract'],
          source: item['source'],
          date: formatter(item['pub_date']),
          webUrl: item['web_url'],
          imageUrl: imageUrl,
        ));
      }

      state = state.copyWith(searchedNews: loadedItems);
    } catch (error) {
      ToastLog.show('Error: Bad request');
    }
  }

  Future<void> getCategoriesNews(String category) async {
    final url = '$nytUrl/topstories/v2/$category.json?api-key=$nytApiKey';

    if (!await CheckConnection.isInternet()) {
      state = state.copyWith(categoryNews: []);
      ToastLog.show('No internet connection');
      return;
    }
    try {
      state = state.copyWith(categoryNews: []);
      var response = await Dio().get(url);
      var jsonResponse;
      if (response.data is String) {
        jsonResponse = json.decode(response.data);
      } else if (response.data is Map<String, dynamic>) {
        jsonResponse = response.data;
      }
      List<Article> loadedItems = [];
      List extractedData = jsonResponse['results'];
      for (var item in extractedData) {
        if (item['title'] == null ||
            item['byline'] == null ||
            item['abstract'] == null ||
            item['published_date'] == null ||
            item['url'] == null) {
          continue;
        }

        String imageUrl;
        if (item['multimedia'] != null && item['multimedia'].isNotEmpty) {
          imageUrl = item['multimedia'][0]['url'];
        } else {
          if (item[url] != null) {
            imageUrl =
                'https://upload.wikimedia.org/wikipedia/commons/0/0e/Nytimes_hq.jpg';
          } else {
            continue;
          }
        }
        loadedItems.add(Article(
          headline: item['title'],
          source: item['byline'],
          description: item['abstract'],
          date: formatter(item['published_date']),
          imageUrl: imageUrl,
          webUrl: item['url'],
        ));
      }
      state = state.copyWith(categoryNews: loadedItems);
    } catch (error) {
      ToastLog.show('Error: Bad request');
    }
  }

  /// FETCH TOP NEWS BY NEWSAPI

  // final String newsApiKey =
  //     FirebaseRemoteConfig.instance.getString('newsApiKey1');

  final String newsApiKey = FirebaseRemoteConfig.instance.getString('newsApikey2'); // key 2

  final newsApiUrl = "https://newsapi.org/v2";

  Future<void> getTopNews() async {
    if (!await CheckConnection.isInternet()) {
      ToastLog.show('No internet connection');
      return;
    }
    try {
      if (!FirebaseAccount.isSignedIn()) {
        final loadedItems = await getHeadlines();
        state = state.copyWith(topNews: loadedItems);
        print('getHeadlines');
      } else {
        state = state.copyWith(topNews: []);
        final lastRead = await _firestore
            .collection('news_mark')
            .doc(FirebaseAccount.getEmail())
            .collection('last_read')
            .get();
        List<Article> loadedItems = [];
        if (lastRead.docs.length < 15) {
          loadedItems = await getHeadlines();
          print('getHeadlines');
        } else {
          if (state.isNewTimeOpenApp) {
            loadedItems = await getGroupRecommend();
            List<Article> loadedItems2 = await getHeadlines();
            loadedItems.addAll(loadedItems2);
            loadedItems.shuffle();
            state = state.copyWith(isNewTimeOpenApp: false);
            print('getGroupRecommend + getHeadlines');
          } else {
            loadedItems = await getUserRecommend();
            print('getUserRecommend');
          }
        }
        state = state.copyWith(topNews: loadedItems);
      }
    } catch (error) {
      ToastLog.show('Error: Bad request');
    }
  }

  Future<void> appendTopNews() async {
    if (state.inAppendProgress) {
      return;
    }
    if (!await CheckConnection.isInternet()) {
      ToastLog.show('No internet connection');
      return;
    } else if (state.topNews.length >= 100) {
      return;
    }
    try {
      state = state.copyWith(inAppendProgress: true);
      if (!FirebaseAccount.isSignedIn()) {
        final loadedItems = await getHeadlines();
        _appendTopNews(loadedItems);
        print('getHeadlines');
      } else {
        final lastRead = await _firestore
            .collection('news_mark')
            .doc(FirebaseAccount.getEmail())
            .collection('last_read')
            .get();

        List<Article> loadedItems = [];
        if (lastRead.docs.length < 15) {
          loadedItems = await getHeadlines();
          print('getHeadlines');
        } else {
          // random user or group
          if (DateTime.now().microsecond % 2 == 0) {
            loadedItems = await getUserRecommend();
            print('getUserRecommend');
          } else {
            loadedItems = await getGroupRecommend();
            print('getGroupRecommend');
          }
        }
        _appendTopNews(loadedItems);
      }
      state = state.copyWith(inAppendProgress: false);
    } catch (error) {
      state = state.copyWith(inAppendProgress: false);
    }
  }

  Future<List<Article>> getHeadlines() async {
    List<String> sources = [
      'bbc-news',
      'cnn',
      'fox-news',
      'reuters',
      'the-wall-street-journal',
      'the-washington-post',
      'the-verge',
      'espn',
      'abc-news',
      'nfl-news',
      'fox-news',
    ];
    List<Article> loadedItems = [];
    // pick 2 sources randomly
    List<String> tmpSource = [];
    for (int i = 0; i < 2; i++) {
      String randomSource;
      do {
        randomSource = sources[DateTime.now().microsecond % sources.length];
      } while (tmpSource.contains(randomSource));
      tmpSource.add(randomSource);
      final url =
          '$newsApiUrl/top-headlines?sources=$randomSource&apiKey=$newsApiKey';
      Response response = await Dio().get(url);
      var jsonResponse = response.data;
      List extractedData = jsonResponse['articles'];
      for (var item in extractedData) {
        if (item['title'] != null &&
            item['author'] != null &&
            item['description'] != null &&
            item['urlToImage'] != null) {
          loadedItems.add(Article(
            headline: item['title'],
            source: item['author'],
            description: item['description'],
            date: formatter(item['publishedAt']),
            imageUrl: item['urlToImage'],
            webUrl: item['url'],
          ));
        }
      }
    }

    // mix _loadedItems
    loadedItems.shuffle();

    // check duplicate
    List<Article> itemsToRemove = [];
    for (var item in loadedItems) {
      if (state.topNews.contains(item)) {
        itemsToRemove.add(item);
      }
    }
    loadedItems.removeWhere((item) => itemsToRemove.contains(item));

    return loadedItems;
  }

  Future<List<Article>> getUserRecommend() async {
    await ref.read(recommenderProvider.notifier).getUserRecommendations(FirebaseAccount.getEmail());
    List<String> keywords = ref.read(recommenderProvider).userRecommendations;

    // pick 1 keywords randomly
    List<Article> loadedItems = [];
    List<String> tmpKeyword = [];
    for (int i = 0; i < 1; i++) {
      String randomKeyword;
      do {
        randomKeyword = keywords[DateTime.now().microsecond % keywords.length];
      } while (tmpKeyword.contains(randomKeyword));
      tmpKeyword.add(randomKeyword);
      final url =
          '$newsApiUrl/everything?q=$randomKeyword&apiKey=$newsApiKey';
      print(url);
      Response response = await Dio().get(url);
      var jsonResponse = response.data;
      List extractedData = jsonResponse['articles'];
      for (var item in extractedData) {
        if (item['title'] != null &&
            item['author'] != null &&
            item['description'] != null &&
            item['urlToImage'] != null
        ) {
          loadedItems.add(Article(
            headline: item['title'],
            source: item['author'],
            description: item['description'],
            date: formatter(item['publishedAt']),
            imageUrl: item['urlToImage'],
            webUrl: item['url'],
          ));
        }
      }
    }

    // mix _loadedItems
    loadedItems.shuffle();

    // get 20 fist items
    loadedItems = loadedItems.sublist(0, loadedItems.length > 20 ? 20 : loadedItems.length - 1);

    // check duplicate
    List<Article> itemsToRemove = [];
    for (var item in loadedItems) {
      if (state.topNews.contains(item)) {
        itemsToRemove.add(item);
      }
    }
    loadedItems.removeWhere((item) => itemsToRemove.contains(item));

    return loadedItems;
  }

  Future<List<Article>> getGroupRecommend() async {
    await ref.read(recommenderProvider.notifier).getGroupRecommendations(FirebaseAccount.getEmail());
    List<String> keywords = ref.read(recommenderProvider).groupRecommendations;

    // pick 1 keywords randomly
    List<Article> loadedItems = [];
    List<String> tmpKeyword = [];
    for (int i = 0; i < 1; i++) {
      String randomKeyword;
      do {
        randomKeyword = keywords[DateTime.now().microsecond % keywords.length];
      } while (tmpKeyword.contains(randomKeyword));
      tmpKeyword.add(randomKeyword);
      final url =
          '$newsApiUrl/everything?q=$randomKeyword&apiKey=$newsApiKey';
      print(url);
      Response response = await Dio().get(url);
      var jsonResponse = response.data;
      List extractedData = jsonResponse['articles'];
      for (var item in extractedData) {
        if (item['title'] != null &&
            item['author'] != null &&
            item['description'] != null &&
            item['urlToImage'] != null) {
          loadedItems.add(Article(
            headline: item['title'],
            source: item['author'],
            description: item['description'],
            date: formatter(item['publishedAt']),
            imageUrl: item['urlToImage'],
            webUrl: item['url'],
          ));
        }
      }
    }
    // mix _loadedItems
    loadedItems.shuffle();
    // get 20 fist items
    loadedItems = loadedItems.sublist(0, loadedItems.length > 20 ? 20 : loadedItems.length - 1);

    // check duplicate
    List<Article> itemsToRemove = [];
    for (var item in loadedItems) {
      if (state.topNews.contains(item)) {
        itemsToRemove.add(item);
      }
    }
    loadedItems.removeWhere((item) => itemsToRemove.contains(item));

    return loadedItems;
  }

  void _appendTopNews(List<Article> articles) {
    List<Article> loadedItems = state.topNews;
    loadedItems.addAll(articles);
    state = state.copyWith(topNews: loadedItems);
  }

  /// FIREBASE

  final _firestore = FirebaseFirestore.instance;

  Future<void> getLikedNews() async {
    if (!await CheckConnection.isInternet()) {
      ToastLog.show('No internet connection');
      return;
    }
    try {
      final value = await _firestore
          .collection('news_mark')
          .doc(FirebaseAccount.getEmail())
          .collection('news')
          .get();
      List<LikedNewsItem> likedNews = [];
      for (var element in value.docs) {
        likedNews.add(LikedNewsItem(
          headline: element['headline'],
          source: element['source'],
          webUrl: element['webUrl'],
          imageUrl: element['imageUrl'],
        ));
      }

      state = state.copyWith(likedNews: likedNews);
    } catch (error) {
      ToastLog.show('Error: Bad request');
    }
  }

  void removeLikedNews(webUrl) {
    FireStoreArticles.removeArticle(
      webUrl: webUrl,
      onSuccess: () {
        getLikedNews();
      },
      onError: (error) {
        ToastLog.show('Error: $error');
      },
    );
  }
}
