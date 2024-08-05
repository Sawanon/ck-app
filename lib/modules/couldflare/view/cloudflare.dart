import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:lottery_ck/utils.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CloudFlarePage extends StatelessWidget {
  const CloudFlarePage({super.key});

  static final controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setBackgroundColor(const Color(0x00000000))
    ..setNavigationDelegate(
      NavigationDelegate(
        onProgress: (int progress) {
          // Update loading bar.
          logger.d(progress);
        },
        onPageStarted: (String url) {},
        onPageFinished: (String url) {},
        onHttpError: (HttpResponseError error) {
          logger.d("error onHttpError");
          Get.snackbar(
            "Too many requests",
            "Please try again or contact admin",
          );
        },
        onWebResourceError: (WebResourceError error) {
          logger.d("error onWebResourceError");
        },
        onNavigationRequest: (NavigationRequest request) {
          // block localhost ! - sawanon:20240805
          // if (request.url.startsWith('http://localhost/')) {
          if (request.url.startsWith('https://www.google.com/')) {
            return NavigationDecision.prevent;
          }
          return NavigationDecision.navigate;
        },
      ),
    )
    ..addJavaScriptChannel(
      "submitform",
      onMessageReceived: (message) {
        logger.d("message: ${message.message}");
      },
    )
    ..enableZoom(false)
    ..loadRequest(Uri.parse('http://localhost:8787/explicit'));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          ElevatedButton(
            onPressed: () {
              navigator?.pop();
              controller.reload();
            },
            child: Text("back flutter"),
          ),
          ElevatedButton(
            onPressed: () async {
              final isCanGoBack = await controller.canGoBack();
              logger.d(isCanGoBack);
              if (isCanGoBack) {
                controller.goBack();
              }
            },
            child: Text("back"),
          ),
          ElevatedButton(
            onPressed: () {
              controller.reload();
            },
            child: Text("Refresh web"),
          ),
        ],
      ),
      body: WebViewWidget(
        controller: controller,
      ),
    );
  }
}
