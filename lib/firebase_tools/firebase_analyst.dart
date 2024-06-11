import 'package:firebase_analytics/firebase_analytics.dart';

class FirebaseAnalyst {
  static const String readEvent = 'read_news';
  static const String searchEvent = 'search_news';
  static const String markFavoriteEvent = 'mark_favorite';
  static const String categoryClickEvent = 'category_click';
  static late FirebaseAnalytics analytics;

  static Future<void> initialize() async {
    analytics = FirebaseAnalytics.instance;
    analytics.setAnalyticsCollectionEnabled(true);
  }

  static Future<void> logEvent(
      {required String name, Map<String, dynamic>? parameters}) async {
    try {
      await _logEvent(name: name, parameters: parameters);
    } catch (e) {
      print('Error: $e');
    }
  }

  static Future<void> _logEvent(
      {required String name, Map<String, dynamic>? parameters}) async {
    try {
      await analytics.logEvent(name: name, parameters: parameters);
      print('Event: $name logged successfully');
    } catch (e) {
      print('Error: $e');
    }
  }

  static String getWebDomain(String url) {
    return Uri.parse(url).host;
  }

  static Future<void> logReadNewsEvent(String url) async {
    final domain = getWebDomain(url);
    await logEvent(name: readEvent, parameters: {'domain': domain});
  }

  static Future<void> logSearchNewsEvent(String query) async {
    await logEvent(name: searchEvent, parameters: {'query': query});
  }

  static Future<void> logMarkFavoriteEvent(String url) async {
    final domain = getWebDomain(url);
    await logEvent(name: markFavoriteEvent, parameters: {'domain': domain});
  }

  static Future<void> logCategoryClickEvent(String category) async {
    await logEvent(
        name: categoryClickEvent, parameters: {'category': category});
  }
}
