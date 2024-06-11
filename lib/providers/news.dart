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
import 'package:news_app_flutter_demo/widgets/liked_news_item.dart';
import '../models/article.dart';
import '../models/searchedArticle.dart';

final newsProvider = StateNotifierProvider<News, NewsState>((ref) {
  return News();
});

class NewsState {
  final List<Article> topNews;
  final List<Article> worldNews;
  final List<SearchedArticle> searchedNews;
  final List<Article> categoryNews;
  final List<LikedNewsItem> likedNews;

  NewsState({
    required this.topNews,
    required this.worldNews,
    required this.searchedNews,
    required this.categoryNews,
    required this.likedNews,
  });

  NewsState copyWith({
    List<Article>? topNews,
    List<Article>? worldNews,
    List<SearchedArticle>? searchedNews,
    List<Article>? categoryNews,
    List<LikedNewsItem>? likedNews,
  }) {
    return NewsState(
      topNews: topNews ?? this.topNews,
      worldNews: worldNews ?? this.worldNews,
      searchedNews: searchedNews ?? this.searchedNews,
      categoryNews: categoryNews ?? this.categoryNews,
      likedNews: likedNews ?? this.likedNews,
    );
  }
}

class News extends StateNotifier<NewsState> {
  News()
      : super(NewsState(
          topNews: [],
          worldNews: [],
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

  // FETCH DATA BY NYT API
  final String nytApiKey = FirebaseRemoteConfig.instance.getString('nytApiKey');
  final nytUrl = "https://api.nytimes.com/svc";

  Future<void> getSearchedNews(String category) async {
    final url =
        '$nytUrl/search/v2/articlesearch.json?q=$category&api-key=$nytApiKey';
    if (!await CheckConnection.isInternet()) {
      ToastLog.show('No internet connection');
      return;
    }
    var response = await Dio().get(url);
    var jsonResponse;

    if (response.data is String) {
      jsonResponse = json.decode(response.data);
    } else if (response.data is Map<String, dynamic>) {
      jsonResponse = response.data;
    }

    List<SearchedArticle> _loadedItems = [];
    List extractedData = jsonResponse['response']['docs'];
    extractedData.forEach((item) {
      if (item['abstract'] == null ||
          item['source'] == null ||
          item['pub_date'] == null ||
          item['web_url'] == null) {
        return;
      }
      String imageUrl;

      // Check if 'multimedia' list is not empty before accessing its elements
      if (item['multimedia'] != null && item['multimedia'].isNotEmpty) {
        imageUrl = 'https://static01.nyt.com/' + item['multimedia'][0]['url'];
      } else {
        if (item['web_url'] != null) {
          imageUrl =
              'https://upload.wikimedia.org/wikipedia/commons/0/0e/Nytimes_hq.jpg';
        } else {
          return;
        }
      }
      _loadedItems.add(SearchedArticle(
        headline: item['abstract'],
        source: item['source'],
        date: formatter(item['pub_date']),
        webUrl: item['web_url'],
        imageUrl: imageUrl,
      ));
    });

    state = state.copyWith(searchedNews: _loadedItems);
  }

  Future<void> getCategoriesNews(String category) async {
    final url = '$nytUrl/topstories/v2/$category.json?api-key=$nytApiKey';
    if (!await CheckConnection.isInternet()) {
      ToastLog.show('No internet connection');
      return;
    }
    var response = await Dio().get(url);
    var jsonResponse;
    if (response.data is String) {
      jsonResponse = json.decode(response.data);
    } else if (response.data is Map<String, dynamic>) {
      jsonResponse = response.data;
    }
    List<Article> _loadedItems = [];
    List extractedData = jsonResponse['results'];
    extractedData.forEach((item) {
      if (item['title'] == null ||
          item['byline'] == null ||
          item['abstract'] == null ||
          item['published_date'] == null ||
          item['url'] == null) {
        return;
      }

      String imageUrl;
      if (item['multimedia'] != null && item['multimedia'].isNotEmpty) {
        imageUrl = item['multimedia'][0]['url'];
      } else {
        if (item[url] != null) {
          imageUrl =
              'https://upload.wikimedia.org/wikipedia/commons/0/0e/Nytimes_hq.jpg';
        } else {
          return;
        }
      }
      _loadedItems.add(Article(
        headline: item['title'],
        source: item['byline'],
        description: item['abstract'],
        date: formatter(item['published_date']),
        imageUrl: imageUrl,
        webUrl: item['url'],
      ));
    });
    state = state.copyWith(categoryNews: _loadedItems);
  }

  // FETCH DATA BY NEWSAPI
  List<String> sources = [
    'bbc-news',
    'cnn',
    'fox-news',
    'reuters',
    'the-wall-street-journal',
    'the-washington-post',
    'axios',
    'the-verge',
    'espn',
    'abc-news',
    'nfl-news',
    'fox-news',
  ];

  // final String newsApiKey =
  //     FirebaseRemoteConfig.instance.getString('newsApiKey1');

  final String newsApiKey = FirebaseRemoteConfig.instance.getString('newsApikey2'); // key 2

  final newsApiUrl = "https://newsapi.org/v2";

  Future<void> getTopNews() async {
    if (!await CheckConnection.isInternet()) {
      ToastLog.show('No internet connection');
      return;
    }
    List<Article> _loadedItems = [];
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
      extractedData.forEach((item) {
        if (item['title'] != null &&
            item['author'] != null &&
            item['description'] != null &&
            item['urlToImage'] != null) {
          _loadedItems.add(Article(
            headline: item['title'],
            source: item['author'],
            description: item['description'],
            date: formatter(item['publishedAt']),
            imageUrl: item['urlToImage'],
            webUrl: item['url'],
          ));
        }
      });
    }

    // mix _loadedItems
    _loadedItems.shuffle();

    state = state.copyWith(topNews: _loadedItems);
  }

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
      value.docs.forEach((element) {
        likedNews.add(LikedNewsItem(
          headline: element['headline'],
          source: element['source'],
          webUrl: element['webUrl'],
          imageUrl: element['imageUrl'],
        ));
      });

      state = state.copyWith(likedNews: likedNews);
    } catch (error) {
      print(error);
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
