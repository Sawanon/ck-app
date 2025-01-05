import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/components/long_button.dart';
import 'package:lottery_ck/modules/notification/controller/promotion.controller.dart';
import 'package:lottery_ck/modules/signup/view/signup.dart';
import 'package:lottery_ck/res/color.dart';
import 'package:lottery_ck/res/icon.dart';
import 'package:lottery_ck/utils.dart';
import 'package:lottery_ck/utils/theme.dart';

class PromotionDetailPage extends StatelessWidget {
  const PromotionDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PromotionController>(
      builder: (controller) {
        return Scaffold(
          backgroundColor: Colors.white,
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
                            : CachedNetworkImage(
                                imageUrl: controller.promotion!['image']!,
                                fit: BoxFit.fitHeight,
                                progressIndicatorBuilder: (
                                  context,
                                  url,
                                  downloadProgress,
                                ) =>
                                    Center(
                                  child: CircularProgressIndicator(
                                    value: downloadProgress.progress,
                                  ),
                                ),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
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
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [AppTheme.softShadow],
                  ),
                  child: LongButton(
                    onPressed: () {
                      controller.collectCoupons();
                    },
                    child: Row(
                      children: [
                        SizedBox(
                          width: 24,
                          height: 24,
                          child: SvgPicture.asset(
                            AppIcon.ticket,
                            colorFilter: const ColorFilter.mode(
                                Colors.white, BlendMode.srcIn),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          "เก็บคูปอง",
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
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
