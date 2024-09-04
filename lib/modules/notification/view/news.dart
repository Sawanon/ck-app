import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/modules/notification/controller/news.controller.dart';
import 'package:lottery_ck/modules/signup/view/signup.dart';
import 'package:lottery_ck/res/color.dart';
import 'package:lottery_ck/utils.dart';

// TODO: use on layout.dart
// canPop: false,
//       onPopInvoked: (didPop) async {
//         logger.w("didPop: $didPop");
//         if (didPop) {
//           return;
//         }
//         final shouldPop = await showDialog(
//           context: context,
//           builder: (context) {
//             return Center(
//               child: Text("boom"),
//             );
//           },
//         );
//       },

class NewsDetailPage extends StatelessWidget {
  const NewsDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NewsController>(builder: (controller) {
      return Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Header(
                onTap: () {
                  // navigator?.pop();
                  Get.back();
                },
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    Container(
                      height: 200,
                      child: controller.news == null
                          ? SizedBox(
                              height: 100,
                              width: double.infinity,
                            )
                          : Image.network(
                              controller.news!.image!,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                logger.d(loadingProgress);
                                if (loadingProgress == null) {
                                  return child;
                                }
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              },
                            ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      controller.news?.name ?? "-",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      controller.news?.detail ?? "-",
                      style: TextStyle(
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
