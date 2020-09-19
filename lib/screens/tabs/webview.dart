import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:async';

class WebviewScreen extends StatefulWidget {
  final dynamic link;
  WebviewScreen({this.link});
  @override
  _WebviewScreenState createState() => _WebviewScreenState();
}

class _WebviewScreenState extends State<WebviewScreen> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Webview'),
        centerTitle: true,
      ),
      body: WebView(
        initialUrl: widget.link,
                    javascriptMode: JavascriptMode.unrestricted,
                   
          onWebViewCreated: (WebViewController webViewController) {
            _controller.complete(webViewController);
          },
          
        
          gestureNavigationEnabled: true,
                    
                   
        navigationDelegate: (NavigationRequest request) {
                    
                    print('allowing navigation to $request');
                    return NavigationDecision.navigate;
                  },
                  
        onPageStarted: (String url) {
                    print('Page started loading: $url');
                  },
        onPageFinished: (String url) {
                    print('Page finished loading: $url');
                  },
         
       ),
      
    );
  }
}