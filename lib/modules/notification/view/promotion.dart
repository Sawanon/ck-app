import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/components/header.dart';
import 'package:lottery_ck/components/long_button.dart';
import 'package:lottery_ck/modules/notification/controller/promotion.controller.dart';
import 'package:lottery_ck/modules/setting/controller/setting.controller.dart';
import 'package:lottery_ck/modules/signup/view/signup.dart';
import 'package:lottery_ck/res/app_locale.dart';
import 'package:lottery_ck/res/color.dart';
import 'package:lottery_ck/res/icon.dart';
import 'package:lottery_ck/utils.dart';
import 'package:lottery_ck/utils/common_fn.dart';
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
                Header(
                  title: AppLocale.promotionDetails.getString(context),
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
                      Builder(
                        builder: (context) {
                          final isNeedKYC =
                              controller.promotion?['is_need_kyc'];
                          final List<Widget> bage = [];
                          if (isNeedKYC == true) {
                            bage.add(
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(2),
                                  border: Border.all(
                                    width: 1,
                                    color: AppColors.primary,
                                  ),
                                ),
                                child: Text(
                                  AppLocale.identityVerificationRequired
                                      .getString(context),
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                            );
                            bage.add(const SizedBox(width: 8));
                          }
                          return Row(
                            children: bage,
                          );
                          // Row(
                          // children: [
                          //   if(isNeedKYC == true)

                          // ],
                          // ),
                        },
                      ),
                      Builder(builder: (context) {
                        final String? endDate =
                            controller.promotion?['end_date'];
                        if (endDate == null) {
                          return const SizedBox.shrink();
                        }
                        final endDateTime = DateTime.parse(endDate).toUtc();
                        return Container(
                          margin: const EdgeInsets.only(top: 8),
                          child: Text(
                            "${AppLocale.expiresOn.getString(context)} ${CommonFn.parseDMY(endDateTime)} ${CommonFn.parseHMS(endDateTime)}",
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 12,
                            ),
                          ),
                        );
                      }),
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
                  child: Builder(builder: (context) {
                    final isNeedKYC =
                        controller.promotion?['is_need_kyc'] == true;
                    final user = SettingController.to.user;
                    final disabled = isNeedKYC && user?.isKYC == false;
                    return LongButton(
                      isLoading: controller.promotion == null,
                      disabled: disabled,
                      onPressed: () {
                        if (controller.promotion == null) {
                          return;
                        }
                        controller.collectCoupons();
                      },
                      child: Row(
                        children: [
                          SizedBox(
                            width: 24,
                            height: 24,
                            child: SvgPicture.asset(
                              AppIcon.ticket,
                              colorFilter: ColorFilter.mode(
                                disabled ? AppColors.disableText : Colors.white,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            AppLocale.collectCoupons.getString(context),
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
