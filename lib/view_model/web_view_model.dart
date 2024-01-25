import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewModel extends ChangeNotifier {
  double _progressValue = 0.0;
  bool isLoaded = false;

  double get progressValue => _progressValue;


  void onProgress(int progress) {
    if(!isLoaded) {
      _progressValue = progress / 100;

      notifyListeners();

      if(_progressValue == 1.0) {
        isLoaded = true;
      }
    }
  }

  WebViewController createWebViewController (String url) {
    return WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: onProgress,
        ),
      )
      ..loadRequest(Uri.parse(url));
  }
}