import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/modules/notification/controller/promotion_point_detail.controller.dart';
import 'package:lottery_ck/modules/signup/view/signup.dart';
import 'package:lottery_ck/res/color.dart';
import 'package:lottery_ck/utils.dart';

class PromotionPointDetailPage extends StatelessWidget {
  const PromotionPointDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PromotionPointDetailController>(
      builder: (controller) {
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
                        child: controller.promotionPoint == null
                            ? SizedBox(
                                height: 100,
                                width: double.infinity,
                              )
                            : Image.network(
                                controller.promotionPoint!['image']!,
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
                        controller.promotionPoint?["name"] ?? "-",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        controller.promotionPoint?['detail'] ?? "-",
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
      },
    );
  }
}
