// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

// Project imports:
import 'package:inshort_clone/controller/feed_controller.dart';
import 'package:inshort_clone/controller/provider.dart';

class WebScreen extends StatefulWidget {
  final String url;
  final bool isFromBottom;
  final PageController? pageController;

  const WebScreen({
    required this.url,
    required this.isFromBottom,
    this.pageController,
  });

  @override
  _WebScreenState createState() => _WebScreenState();
}

class _WebScreenState extends State<WebScreen> {
  bool loading = true;

  late final WebViewController _webViewController;
  String? _currentUrl;

  @override
  void initState() {
    super.initState();
    final url = widget.isFromBottom
        ? widget.url
        : Provider.of<FeedProvider>(context, listen: false).getNewsURL;
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (_) {
            setState(() {
              loading = false;
            });
          },
        ),
      );
    _loadUrl(url);
  }

  void _loadUrl(String url) {
    if (_currentUrl != url) {
      _currentUrl = url;
      loading = true;
      _webViewController.loadRequest(Uri.parse(url));
    }
  }

  @override
  Widget build(BuildContext context) {
    String url = widget.isFromBottom
        ? widget.url
        : Provider.of<FeedProvider>(context).getNewsURL;
    _loadUrl(url);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.black,
        leading: IconButton(
            icon: Icon(FeatherIcons.chevronLeft),
            onPressed: () {
              widget.isFromBottom
                  ? Navigator.pop(context)
                  : widget.pageController != null
                      ? widget.pageController!.jumpToPage(0)
                      : FeedController.addCurrentPage(1);
            }),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.replay),
            onPressed: () {
              setState(() {
                loading = true;
              });
              _webViewController.reload();
            },
          ),
        ],
        title: Text(
          url.split("/")[2],
          style: TextStyle(fontWeight: FontWeight.w300, fontSize: 12),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          loading
              ? SizedBox(height: 3, child: LinearProgressIndicator())
              : Container(),
          Expanded(
            child: WebViewWidget(
              controller: _webViewController,
            ),
          ),
        ],
      ),
    );
  }
}
