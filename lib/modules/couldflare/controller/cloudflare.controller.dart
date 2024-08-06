import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/route/route_name.dart';
import 'package:lottery_ck/utils.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CloudFlareController extends GetxController {
  final argument = Get.arguments;
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
    ..enableZoom(false)
    ..loadRequest(Uri.parse('http://localhost:3000'));

  Future<void> verifyToken(String token) async {
    final dio = Dio();
    final response = await dio.post(
      "http://localhost:3000/verifyCloudflare",
      data: {
        "cf-turnstile-response": token,
      },
    );
    // logger.d(response.data);
    if (response.statusCode == 200 &&
        response.data['data']['action'] == 'signin') {
      if (argument["whenSuccess"] is Function) {
        argument["whenSuccess"]();
      }
      return;
    }
    if (argument["onFailed"] is Function) {
      argument["onFailed"]();
    }
  }

  @override
  void onInit() {
    controllerWebview.addJavaScriptChannel(
      "submitform",
      onMessageReceived: (data) {
        verifyToken(data.message);
      },
    );
    controllerWebview.setNavigationDelegate(
      NavigationDelegate(
        onProgress: (int progress) {},
        onPageStarted: (String url) {},
        onPageFinished: (String url) {},
        onHttpError: (HttpResponseError error) {
          Get.snackbar(
            "Too many requests",
            "Please try again or contact admin",
          );
        },
        onWebResourceError: (WebResourceError error) {
          logger.d("error onWebResourceError");
          if (argument["onWebResourceError"] is Function) {
            argument["onWebResourceError"]();
          }
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
    super.onInit();
  }

  @override
  void onClose() {
    // open blank page for visit again - sawanon:20240806
    controllerWebview.removeJavaScriptChannel("submitform");
    controllerWebview.loadRequest(Uri.parse('about:blank'));
    super.onClose();
  }
}
