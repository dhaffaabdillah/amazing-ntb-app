import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class BMKGPage extends StatefulWidget {
  final url;
  BMKGPage(this.url);
  
  @override
  createState() => _BMKGPageState(this.url);
}

class _BMKGPageState extends State<BMKGPage> {
  var _url;
  final _key = UniqueKey();
  _BMKGPageState(this._url);
  
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