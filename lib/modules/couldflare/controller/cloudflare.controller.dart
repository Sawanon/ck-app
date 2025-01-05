import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/res/constant.dart';
import 'package:lottery_ck/utils.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CloudFlareController extends GetxController {
  static CloudFlareController get to => Get.find();
  Function? callback;
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
    // ..enableZoom(false)
    ..loadRequest(Uri.parse("${AppConst.apiUrl}/verify"));

  Future<void> verifyToken(String token) async {
    try {
      final dio = Dio();
      final response = await dio.post(
        // "${AppConst.cloudfareUrl}/verifyCloudflare",
        "${AppConst.apiUrl}/verify",
        data: {
          "cf-turnstile-response": token,
        },
      );
      // logger.d(response.data);
      if (response.statusCode == 200 &&
          response.data['data']['action'] == 'signin') {
        if (argument != null && argument["whenSuccess"] is Function) {
          argument["whenSuccess"]();
        }
        return;
      }
      if (argument != null && argument["onFailed"] is Function) {
        argument["onFailed"]();
      }
    } on DioException catch (e) {
      if (e.response != null) {
        logger.e(e.response?.statusCode);
        logger.e(e.response?.statusMessage);
        logger.e(e.response?.data);
      }
    }
  }

  @override
  void onInit() {
    controllerWebview.addJavaScriptChannel(
      "submitform",
      onMessageReceived: (data) {
        if (callback != null) {
          callback!();
        }
        verifyToken(data.message);
      },
    );
    // if (Platform.isAndroid) {
    //   controllerWebview.enableZoom(true);
    // }
    controllerWebview.setNavigationDelegate(
      NavigationDelegate(
        onProgress: (int progress) {},
        onPageStarted: (String url) {},
        onPageFinished: (String url) {},
        onHttpError: (HttpResponseError error) {
          // logger.e("onHttpError: $error");
          // logger.e('onHttpError: ${error.response?.statusCode}');
          // logger.e('onHttpError: ${error.response}');
          // Get.snackbar(
          //   "Too many requests",
          //   "Please try again or contact admin",
          // );
        },
        onWebResourceError: (WebResourceError error) {
          logger.e("error onWebResourceError:");
          logger.e(error.toString());
          logger.e(error.description);
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

  void setCallback(Function callback) {
    this.callback = callback;
  }

  @override
  void onClose() {
    // open blank page for visit again - sawanon:20240806
    controllerWebview.removeJavaScriptChannel("submitform");
    controllerWebview.loadRequest(Uri.parse('about:blank'));
    super.onClose();
  }
}
