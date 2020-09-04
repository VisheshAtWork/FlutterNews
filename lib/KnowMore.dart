import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class KnowMore extends StatefulWidget {
  final url;
  KnowMore(this.url);
  @override
  createState() => _KnowMoreState(this.url);
}

class _KnowMoreState extends State<KnowMore> {
  var _url;
  final _key = UniqueKey();
  _KnowMoreState(this._url);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Column(
          children: [
            Expanded(
                child: WebView(
                    key: _key,
                    javascriptMode: JavascriptMode.unrestricted,
                    initialUrl: _url))
          ],
        ));
  }
}
