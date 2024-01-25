import 'package:dictum/component/main_app_bar.dart';
import 'package:dictum/view_model/web_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class WebViewScreen extends StatelessWidget {
  const WebViewScreen({super.key, required this.url});

  final String url;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(
        text: AppLocalizations.of(context)!.dictum,
      ),
      body: ChangeNotifierProvider<WebViewModel>(
        create: (context) => WebViewModel(),
        child: Column(
          children: [
            const _ProgressIndicator(),
            Expanded(
              child: _WebView(url: url),
            ),
          ],
        ),
      ),
    );
  }
}

class _WebView extends StatelessWidget {
  const _WebView({
    required this.url,
  });

  final String url;

  @override
  Widget build(BuildContext context) {
    final model = context.read<WebViewModel>();

    return WebViewWidget(
      controller: model.createWebViewController(url),
    );
  }
}

class _ProgressIndicator extends StatelessWidget {
  const _ProgressIndicator();

  @override
  Widget build(BuildContext context) {
    final model = context.watch<WebViewModel>();

    return model.progressValue != 1.0
        ? LinearProgressIndicator(
            value: model.progressValue,
            backgroundColor: Colors.grey,
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
          )
        : const SizedBox.shrink();
  }
}
