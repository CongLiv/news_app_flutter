import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:news_app_flutter_demo/helpers/check_connection.dart';

import '../firebase_options.dart';

class FirebaseConfig {
  static Future<void> initRemoteConfig() async {
    try {
      await _initRemoteConfig();
    } catch (e) {
      print('Error: $e');
    }
  }

  static Future<void> _initRemoteConfig() async {
    final remoteConfig = FirebaseRemoteConfig.instance;
    await remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(seconds: 10),
      minimumFetchInterval: const Duration(hours: 1),
    ));

    await remoteConfig.setDefaults({
      'nytApiKey': 'abc',
      'newsApiKey1': 'abc',
      'newsApiKey2': 'abc',
    });

    if (await CheckConnection.isInternet()) {
      await remoteConfig.fetchAndActivate();
    }
  }

  static Future<void> initializeApp() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
}
