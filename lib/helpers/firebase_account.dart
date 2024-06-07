import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAccount {
  static bool isSignedIn() {
    FirebaseAuth auth = FirebaseAuth.instance;
    return auth.currentUser != null;
  }

  static String getEmail() {
    FirebaseAuth auth = FirebaseAuth.instance;
    return auth.currentUser!.email!;
  }

  static Future<void> signOut({onSuccess, onError}) async {
    try {
      final auth = FirebaseAuth.instance;
      await auth.signOut();
      if (onSuccess != null) {
        onSuccess();
      }
    } catch (e) {
      if (onError != null) {
        onError(e);
      }
    }
  }

  static Future<User?> signIn(
      {required String email,
      required String password,
      onSuccess,
      onError}) async {
    try {
      final auth = FirebaseAuth.instance;
      final userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (onSuccess != null) {
        onSuccess();
      }
      return userCredential.user;
    } catch (e) {
      if (onError != null) {
        onError(e);
      }
      return null;
    }
  }

  static Future<User?> signUp(
      {required String email,
      required String password,
      onSuccess,
      onError}) async {
    try {
      final auth = FirebaseAuth.instance;
      final userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (onSuccess != null) {
        onSuccess();
      }
      return userCredential.user;
    } catch (e) {
      if (onError != null) {
        onError(e);
      }
      return null;
    }
  }
}
