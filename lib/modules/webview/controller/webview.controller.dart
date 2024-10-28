import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/res/constant.dart';
import 'package:lottery_ck/utils.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CustomWebviewController extends GetxController {
  final argument = Get.arguments;
  bool isLoading = true;
  WebViewController controllerWebview = WebViewController()
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
    );
  // ..enableZoom(false)
  // ..loadRequest(Uri.parse("${AppConst.apiUrl}/verify"));

  void configWebview() async {
    controllerWebview.addJavaScriptChannel(
      "zinzae",
      onMessageReceived: (data) {
        logger.d(jsonEncode(data.message));
      },
    );
    if (argument['url'] != null) {
      logger.d(argument['url']);
      await controllerWebview.loadRequest(Uri.parse(argument['url']));
      await Future.delayed(const Duration(seconds: 1, milliseconds: 300)).then(
        (value) {
          // controllerWebview.loadRequest(Uri.parse(argument['url']));
          isLoading = false;
          update();
        },
      );
    }
  }

  @override
  void onInit() {
    configWebview();
    super.onInit();
  }

  @override
  void onClose() {
    controllerWebview.loadRequest(Uri.parse('about:blank'));
    super.onClose();
  }
}
