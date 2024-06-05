import 'dart:convert';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:news_app_flutter_demo/helpers/check_connection.dart';
import 'package:news_app_flutter_demo/widgets/liked_news_item.dart';
import '../models/article.dart';
import '../models/searchedArticle.dart';

class News extends ChangeNotifier {
  final String apiKey = "QdjEczdPCm0YwTGBlGEEy8uTBblGouk0";
  final baseUrl = "https://api.nytimes.com/svc";
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  List<Article> _topNews = [];
  List<Article> _worldNews = [];
  List<SearchedArticle> _searchedNews = [];
  List<SearchedArticle> _loadingItems = [];
  List<Article> _categoryNews = [];
  List<Article> _loadedItems = [];
  List<LikedNewsItem> _likedNews = [];

  List<Article> get categoryNews {
    return [..._categoryNews];
  }

  List<Article> get worldNews {
    return [..._worldNews];
  }

  List<Article> get topNews {
    return [..._topNews];
  }

  List<SearchedArticle> get searchedNews {
    return [..._searchedNews];
  }

  List<LikedNewsItem> get likedNews {
    return [..._likedNews];
  }

  String formatter(String date) {
    DateTime parsedDate = DateTime.parse(date);
    var formattedDate = DateFormat('dd/MM/yyyy').format(parsedDate);
    return formattedDate;
  }

// by nytimes.com
  Future<void> getSearchedNews(String category) async {
    final url =
        '$baseUrl/search/v2/articlesearch.json?q=$category&api-key=$apiKey';
    if (!await CheckConnection.isInternet()) {
      showToasts('No internet connection');
      return;
    }
    var response = await Dio().get(url);
    var jsonResponse;

    if (response.data is String) {
      jsonResponse = json.decode(response.data);
    } else if (response.data is Map<String, dynamic>) {
      jsonResponse = response.data;
    }

    _loadingItems = []; // Clear the list before adding new items

    List extractedData = jsonResponse['response']['docs'];
    extractedData.forEach((item) {
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

      _loadingItems.add(SearchedArticle(
        headline: item['abstract'],
        source: item['source'],
        date: formatter(item['pub_date']),
        webUrl: item['web_url'],
        imageUrl: imageUrl,
      ));
    });
    _searchedNews = _loadingItems;
  }

  Future<void> getCategoriesNews(String category) async {
    final url = '$baseUrl/topstories/v2/$category.json?api-key=$apiKey';
    if (!await CheckConnection.isInternet()) {
      showToasts('No internet connection');
      return;
    }
    var response = await Dio().get(url);
    var jsonResponse;
    if (response.data is String) {
      jsonResponse = json.decode(response.data);
    } else if (response.data is Map<String, dynamic>) {
      jsonResponse = response.data;
    }
    List extractedData = jsonResponse['results'];
    _loadedItems = [];
    extractedData.forEach((item) {
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
    _categoryNews = _loadedItems;
  }

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

  // by newsapi.org
  // final String newsApiKey = "3c6c2af37aa3470e88d0731029a15469";
  final String newsApiKey = "a1644628a7454cfa92cd537c92e37ee4";
  final String newsBaseUrl = "https://newsapi.org/v2";

  Future<void> getTopNews() async {
    if (!await CheckConnection.isInternet()) {
      showToasts('No internet connection');
      return;
    }
    _loadedItems = [];
    // pick 2 sources randomly
    List<String> tmpSource = [];
    for (int i = 0; i < 2; i++) {
      String randomSource;
      do {
        randomSource = sources[DateTime.now().microsecond % sources.length];
      } while (tmpSource.contains(randomSource));
      tmpSource.add(randomSource);
      final url =
          '$newsBaseUrl/top-headlines?sources=$randomSource&apiKey=$newsApiKey';
      Response response = await Dio().get(url);
      var jsonResponse = response.data;
      List extractedData = jsonResponse['articles'];
      extractedData.forEach((item) {
        if (item['title'] != null &&
            item['author'] != null &&
            item['description'] != null &&
            item['urlToImage'] != null &&
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
    _topNews = _loadedItems;
  }

  Future<void> getLikedNews() async {
    if (!await CheckConnection.isInternet()) {
      showToasts('No internet connection');
      return;
    }

    // get liked news from firestore
    try {
      final value = await _firestore
          .collection('news_mark')
          .doc(_auth.currentUser!.email)
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
      _likedNews = likedNews;
    } catch (error) {
      print(error);
    }
  }

  Future<void> removeLikedNews(webUrl) async {
    try {
      await _firestore
          .collection('news_mark')
          .doc(_auth.currentUser!.email)
          .collection('news')
          .where('webUrl', isEqualTo: webUrl)
          .get()
          .then((value) {
        value.docs.forEach((element) {
          element.reference.delete();
        });
      });
      _likedNews.removeWhere((element) => element.webUrl == webUrl);
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }

  void showToasts(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
    );
  }
}
