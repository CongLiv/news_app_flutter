import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_account.dart';

class FireStoreArticles {
  static bool isProcessing = false;

  static void addArticle({
    required String headline,
    required String description,
    required String source,
    required String webUrl,
    required String imageUrl,
    onSuccess,
    onError,
  }) {
    if (isProcessing) {
      onError('On Processing');
      return;
    }
    try {
      isProcessing = true;
      FirebaseFirestore.instance
          .collection('news_mark')
          .doc(FirebaseAccount.getEmail())
          .collection('news')
          .add({
        'headline': headline,
        'description': description,
        'source': source,
        'webUrl': webUrl,
        'imageUrl': imageUrl,
      });
    } catch (e) {
      if (onError != null) {
        onError(e);
      }
    } finally {
      isProcessing = false;
      if (onSuccess != null) {
        onSuccess();
      }
    }
  }

  static Future<void> removeArticle(
      {required String webUrl, onSuccess, onError}) async {
    if (isProcessing) {
      onError('On Processing');
      return;
    }
    try {
      isProcessing = true;
      await FirebaseFirestore.instance
          .collection('news_mark')
          .doc(FirebaseAccount.getEmail())
          .collection('news')
          .where('webUrl', isEqualTo: webUrl)
          .get()
          .then((value) {
        value.docs.forEach((element) {
          element.reference.delete();
        });
      });
    } catch (e) {
      if (onError != null) {
        onError(e);
      }
    } finally {
      isProcessing = false;
      if (onSuccess != null) {
        onSuccess();
      }
    }
  }

  static Future<bool> checkArticleMarked(String webUrl) async {
    final value = await FirebaseFirestore.instance
        .collection('news_mark')
        .doc(FirebaseAccount.getEmail())
        .collection('news')
        .where('webUrl', isEqualTo: webUrl)
        .get();
    return value.docs.isNotEmpty;
  }
}
