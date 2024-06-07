import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:news_app_flutter_demo/helpers/urlLauncher.dart';
import 'package:news_app_flutter_demo/widgets/title_name.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../helpers/const_data.dart';
import '../../helpers/share_article.dart';

class WebviewContainer extends StatefulWidget {
  final String url;

  WebviewContainer({super.key, required this.url});

  @override
  _WebviewContainerState createState() => _WebviewContainerState();
}

class _WebviewContainerState extends State<WebviewContainer> {
  late final WebViewController _controller;
  bool isLoading = true;
  bool isSet = false;

  void setLoad(bool load) {
    setState(() {
      isLoading = load;
      isSet = true;
    });
  }

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
        onProgress: (int progress) {
          if (progress > 70 && !isSet) {
            setLoad(false);
          }
        },
      ))
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: redViettel),
        backgroundColor: Theme.of(context).colorScheme.secondary,
        elevation: 0,
        centerTitle: true,
        title: TitleName(text: appNameLogo),
        actions: [
          IconButton(
            icon: Icon(
              Icons.share,
            ),
            onPressed: () => ShareArticle.shareArticle(widget.url),
          ),
          PopupMenuButton(
            onSelected: (value) {
              if (value == 'Reload') {
                setState(() {
                  isLoading = true;
                  isSet = false;
                });
                _controller.reload();
              } else if (value == 'Mark') {
                // Mark article
              } else if (value == 'Open') {
                UrlLauncher.launchUrlLink(widget.url);
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                    child: Text('Reload',
                        style: TextStyle(fontFamily: 'FS PFBeauSansPro')),
                    value: 'Reload'),
                PopupMenuItem(
                  child: Text(
                    'Mark Article',
                    style: TextStyle(fontFamily: 'FS PFBeauSansPro'),
                  ),
                  value: 'Mark',
                ),
                PopupMenuItem(
                  child: Text(
                    'Open in Browser',
                    style: TextStyle(fontFamily: 'FS PFBeauSansPro'),
                  ),
                  value: 'Open',
                ),
              ];
            },
          )
        ],
      ),
      body: Stack(
        children: [
          WebViewWidget(
            controller: _controller,
          ),
          if (isLoading)
            Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(redViettel),
              ),
            ),
        ],
      ),
    );
  }
}
