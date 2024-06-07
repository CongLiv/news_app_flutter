import 'package:url_launcher/url_launcher.dart';

class UrlLauncher {
  static void launchUrlLink(String url) async {
    Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalNonBrowserApplication)) {
      throw Exception('Could not launch $url');
    }
  }
}
