import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAccount {

  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static bool isSignedIn() {
    return _auth.currentUser != null;
  }

  static String getEmail() {
    return _auth.currentUser!.email!;
  }

  static Future<void> signOut({onSuccess, onError}) async {
    try {
      await _auth.signOut();
      if (onSuccess != null) {
        onSuccess();
      }
    } catch (e) {
      if (onError != null) {
        onError(e);
      }
    }
  }

  static Future<User?> signIn({required String email, required String password, onSuccess, onError}) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
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

  static Future<User?> signUp({required String email, required String password, onSuccess, onError}) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
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