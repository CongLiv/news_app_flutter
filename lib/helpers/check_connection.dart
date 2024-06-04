import 'package:connectivity_plus/connectivity_plus.dart';

class CheckConnection {
  static Future<bool> isInternet() async {
    final List<ConnectivityResult> connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult.contains(ConnectivityResult.none)) {
      return false;
    }
    return true;
  }
}