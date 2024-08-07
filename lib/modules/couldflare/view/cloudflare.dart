import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import 'package:lottery_ck/modules/couldflare/controller/cloudflare.controller.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';

class CloudFlarePage extends StatelessWidget {
  const CloudFlarePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CloudFlareController>(builder: (controller) {
      return WebViewWidget(
        controller: controller.controllerWebview,
      );
    });
  }
}
