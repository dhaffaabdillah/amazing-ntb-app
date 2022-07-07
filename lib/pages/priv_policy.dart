import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PrivyPolicyPage extends StatefulWidget {
  final url;
  PrivyPolicyPage(this.url);
  
  @override
  createState() => _PrivyPolicyPageState(this.url);
}

class _PrivyPolicyPageState extends State<PrivyPolicyPage> {
  var _url;
  final _key = UniqueKey();
  _PrivyPolicyPageState(this._url);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Privacy Policy").tr(),
        ),
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