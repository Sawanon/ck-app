import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/modules/webview/controller/webview.controller.dart';
import 'package:lottery_ck/res/color.dart';
import 'package:lottery_ck/res/icon.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebviewPage extends StatelessWidget {
  const WebviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CustomWebviewController>(
      builder: (controller) {
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
                          Get.back();
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
                  child: controller.isLoading
                      ? Container(
                          color: AppColors.zinZaeBackground,
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : WebViewWidget(
                          controller: controller.controllerWebview,
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
