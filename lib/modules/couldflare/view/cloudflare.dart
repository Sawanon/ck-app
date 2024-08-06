import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import 'package:lottery_ck/modules/couldflare/controller/cloudflare.controller.dart';
import 'package:lottery_ck/utils.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CloudFlarePage extends StatelessWidget {
  const CloudFlarePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CloudFlareController>(builder: (controller) {
      return Scaffold(
        appBar: AppBar(
          actions: [
            ElevatedButton(
              onPressed: () async {
                final isCanGoBack =
                    await controller.controllerWebview.canGoBack();
                logger.d(isCanGoBack);
                if (isCanGoBack) {
                  controller.controllerWebview.goBack();
                }
              },
              child: Text("back"),
            ),
            ElevatedButton(
              onPressed: () {
                controller.controllerWebview.reload();
              },
              child: Text("Refresh web"),
            ),
          ],
        ),
        body: WebViewWidget(
          controller: controller.controllerWebview,
        ),
      );
    });
  }
}
