import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/modules/webview/controller/webview.controller.dart';
import 'package:lottery_ck/res/color.dart';
import 'package:lottery_ck/res/icon.dart';
import 'package:lottery_ck/utils.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebviewPageV2 extends StatefulWidget {
  final String url;
  final void Function() onBack;
  final EdgeInsetsGeometry? padding;
  final void Function(JavaScriptMessage data) onMessageReceived;

  const WebviewPageV2({
    super.key,
    required this.url,
    required this.onBack,
    this.padding,
    required this.onMessageReceived,
  });

  @override
  State<WebviewPageV2> createState() => _WebviewPageV2State();
}

class _WebviewPageV2State extends State<WebviewPageV2> {
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
          logger.e("error onHttpError: $error");
          logger.e(
              "error onHttpError: ${error.response?.headers}, code:${error.response?.statusCode}");
        },
        onWebResourceError: (WebResourceError error) {
          logger.d("error onWebResourceError");
          logger
              .e('❌ WebView Error: ${error.errorCode} - ${error.description}');
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
    ..setUserAgent(
      'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36',
    );

  void configWebview(String url) async {
    // controllerWebview.addJavaScriptChannel(
    //   "zinzae",
    //   onMessageReceived: (data) {
    //     logger.d(jsonEncode(data.message));
    //   },
    // );

    await controllerWebview.loadRequest(Uri.parse(url));
    await Future.delayed(const Duration(seconds: 1, milliseconds: 300)).then(
      (value) {
        // controllerWebview.loadRequest(Uri.parse(argument['url']));
        setIsLoading(false);
      },
    );
  }

  void setIsLoading(bool isLoading) {
    setState(() {
      this.isLoading = isLoading;
    });
  }

  void setup() async {
    setIsLoading(true);
    logger.w(widget.url);
    configWebview(widget.url);

    controllerWebview.addJavaScriptChannel(
      "zinzae",
      onMessageReceived: widget.onMessageReceived,
      // onMessageReceived: (data) {
      //   logger.d(jsonEncode(data.message));
      // },
    );
  }

  void onBack() {
    widget.onBack();
  }

  @override
  void initState() {
    logger.w("initState");
    setup();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant WebviewPageV2 oldWidget) {
    setup();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.zinZaeBackground,
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              color: AppColors.zinZaeBackground,
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      onBack();
                    },
                    child: Container(
                      color: AppColors.zinZaeBackground,
                      padding: const EdgeInsets.all(6),
                      width: 48,
                      height: 48,
                      child: SvgPicture.asset(
                        AppIcon.arrowLeft,
                        colorFilter: const ColorFilter.mode(
                            Colors.white, BlendMode.srcIn),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: isLoading
                  ? Container(
                      color: AppColors.zinZaeBackground,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : Container(
                      padding: widget.padding,
                      child: WebViewWidget(
                        controller: controllerWebview,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
