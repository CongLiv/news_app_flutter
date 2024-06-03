import 'package:share_plus/share_plus.dart';

class ShareArticle {
  static void shareArticle(String url) {
    Share.share("Check out this article: $url");
  }
}