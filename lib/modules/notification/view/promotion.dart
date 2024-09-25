import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/modules/notification/controller/promotion.controller.dart';
import 'package:lottery_ck/modules/signup/view/signup.dart';
import 'package:lottery_ck/res/color.dart';
import 'package:lottery_ck/utils.dart';

class PromotionDetailPage extends StatelessWidget {
  const PromotionDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PromotionController>(builder: (controller) {
      return Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              HeaderCK(
                onTap: () {
                  navigator?.pop();
                },
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    Container(
                      height: 200,
                      child: controller.promotion == null
                          ? SizedBox(
                              height: 100,
                              width: double.infinity,
                            )
                          : Image.network(
                              controller.promotion!['image']!,
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
                      controller.promotion?["name"] ?? "-",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      controller.promotion?['detail'] ?? "-",
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
