import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Article_view extends StatelessWidget {
  // var url = 'https://www.google.com';
  final url;

  final key = UniqueKey();

  Article_view({Key key, this.url}) : super(key: key);

  // MyPlaceholderWidget(String url) {
  //   this.url = url;
  // }

  @override
  Widget build(BuildContext context) {
    print(url);
    return Scaffold(
      appBar: AppBar(
        title: Text(url),
        leading: InkWell(
          child: Icon(Icons.arrow_back),
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: WebView(
          key: key,
          javascriptMode: JavascriptMode.unrestricted,
          initialUrl: widget.url,
          onWebViewCreated: (WebViewController webViewController) {}),
    );
  }
}
