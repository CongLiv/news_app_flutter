import 'dart:convert';
import 'dart:async';
import 'dart:math';
import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import '../models/article.dart';
import '../models/searchedArticle.dart';

// by nytimes.com
class News extends ChangeNotifier {
  final String apiKey = "QdjEczdPCm0YwTGBlGEEy8uTBblGouk0";
  final baseUrl = "https://api.nytimes.com/svc";

  List<Article> _topNews = [];
  List<Article> _worldNews = [];
  List<SearchedArticle> _searchedNews = [];
  List<SearchedArticle> _loadingItems = [];
  List<Article> _categoryNews = [];
  List<Article> _loadedItems = [];

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

  String formatter(String date) {
    DateTime parsedDate = DateTime.parse(date);
    var formattedDate = DateFormat('dd/MM/yyyy').format(parsedDate);
    return formattedDate;
  }

  Future<void> getSearchedNews(String category) async {
    final url =
        '$baseUrl/search/v2/articlesearch.json?q=$category&api-key=$apiKey';
    var response = await Dio().get(url);
    var jsonResponse;
    if(response.data is String) {
      jsonResponse = json.decode(response.data);
    } else if(response.data is Map<String, dynamic>) {
      jsonResponse = response.data;
    }

    List extractedData = jsonResponse['response']['docs'];
    _loadedItems = [];
    extractedData.forEach((item) {
      _loadingItems.add(SearchedArticle(
        headline: item['abstract'],
        source: item['source'],
        date: formatter(item['pub_date']),
        webUrl: item['web_url'],
      ));
    });
    _searchedNews = _loadingItems;
  }

  Future<void> getCategoriesNews(String category) async {
    final url = '$baseUrl/topstories/v2/$category.json?api-key=$apiKey';
    var response = await Dio().get(url);
    var jsonResponse = json.decode(response.data);
    List extractedData = jsonResponse['results'];
    _loadedItems = [];
    extractedData.forEach((item) {
      _loadedItems.add(Article(
        headline: item['title'],
        source: item['byline'],
        description: item['abstract'],
        date: formatter(item['published_date']),
        imageUrl: item['multimedia'][0]['url'],
        webUrl: item['url'],
      ));
    });
    _categoryNews = _loadedItems;
  }

  Future<void> getWorldNews() async {
    final url = '$baseUrl/topstories/v2/world.json?api-key=$apiKey';
    var response = await Dio().get(url);
    var jsonResponse = json.decode(response.data);
    List extractedData = jsonResponse['results'];
    _loadedItems = [];
    extractedData.forEach((item) {
      _loadedItems.add(Article(
        headline: item['title'],
        source: item['byline'],
        description: item['abstract'],
        date: formatter(item['published_date']),
        imageUrl: item['multimedia'][0]['url'],
        webUrl: item['url'],
      ));
    });
    _worldNews = _loadedItems;
  }


  // by newsapi.org
  final String newsApiKey = "3c6c2af37aa3470e88d0731029a15469";
  Future<void> getTopNews() async {
    final url =
        'https://newsapi.org/v2/everything?q=keyword&apiKey=$newsApiKey';
    Response response = await Dio().get(url);
    // var jsonResponse = json.decode(response.body);
    var jsonResponse = response.data;
    List extractedData = jsonResponse['articles'];
    _loadedItems = [];
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
    _topNews = _loadedItems;
    print(_topNews.length + 1);
  }


}
