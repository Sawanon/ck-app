import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/components/header.dart';
import 'package:lottery_ck/components/input_text.dart';
import 'package:lottery_ck/components/long_button.dart';
import 'package:lottery_ck/modules/point/controller/buy_point.controller.dart';
import 'package:lottery_ck/modules/setting/controller/setting.controller.dart';
import 'package:lottery_ck/res/app_locale.dart';
import 'package:lottery_ck/res/color.dart';
import 'package:lottery_ck/res/icon.dart';
import 'package:lottery_ck/utils/common_fn.dart';
import 'package:lottery_ck/utils/theme.dart';
import 'package:skeletonizer/skeletonizer.dart';

class TopupPoint extends StatelessWidget {
  const TopupPoint({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BuyPointController>(builder: (controller) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Column(
            children: [
              Header(
                title: AppLocale.topupPoints.getString(context),
              ),
              Expanded(
                child: ListView(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: const BoxDecoration(
                                border: Border(
                                  right: BorderSide(
                                    width: 1,
                                    color: AppColors.borderGray,
                                  ),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(2),
                                    width: 48,
                                    height: 48,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(60),
                                      gradient: const LinearGradient(
                                        colors: [
                                          AppColors.redGradient,
                                          AppColors.yellowGradient,
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                    ),
                                    child: Container(
                                      clipBehavior: Clip.hardEdge,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(60),
                                      ),
                                      child: Builder(
                                        builder: (context) {
                                          // if (avatar == '') {
                                          final profileImage = SettingController
                                              .to.profileByte.value;
                                          if (profileImage != null) {
                                            return Image.memory(profileImage,
                                                fit: BoxFit.cover);
                                          }
                                          return const Icon(
                                            Icons.person,
                                            color: AppColors.primary,
                                            size: 32,
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Builder(builder: (context) {
                                    final user = SettingController.to.user;
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          user?.firstName ?? "-",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16,
                                          ),
                                        ),
                                        Text(
                                          CommonFn.hidePhoneNumber(
                                              user?.phoneNumber),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 12,
                                            color: AppColors.textPrimary,
                                          ),
                                        ),
                                      ],
                                    );
                                  }),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: Obx(
                              () {
                                final point = SettingController.to.point.value;
                                return Column(
                                  children: [
                                    Text(
                                      AppLocale.remainingPoints
                                          .getString(context),
                                      style: const TextStyle(
                                        fontSize: 12,
                                      ),
                                    ),
                                    Text(
                                      "${CommonFn.parseMoney(point)} ${AppLocale.point.getString(context)}",
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      color: Colors.white,
                      padding: EdgeInsets.all(16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocale.selectNumberOfPoints.getString(context),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Skeletonizer(
                            enabled: controller.isLoadingPoint,
                            child: Row(
                              children: controller.pointList['1']!.map((point) {
                                return Expanded(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          controller.onChangePoint("$point");
                                          controller.onClickPointList(point);
                                        },
                                        child: Container(
                                          margin: EdgeInsets.only(
                                            left: point == 1000 ? 0 : 8,
                                          ),
                                          alignment: Alignment.center,
                                          width: double.infinity,
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 8,
                                            horizontal: 8,
                                          ),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              width: 1,
                                              color: controller
                                                          .selectedPointList ==
                                                      point
                                                  ? AppColors.primary
                                                  : AppColors.inputBorder,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Column(
                                            children: [
                                              Text(
                                                CommonFn.parseMoney(point),
                                              ),
                                              Text(
                                                AppLocale.point
                                                    .getString(context),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        "${CommonFn.parseMoney(point * controller.pointRaio)} ${AppLocale.lak.getString(context)}",
                                        style: const TextStyle(
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Skeletonizer(
                            enabled: controller.isLoadingPoint,
                            child: Row(
                              children: controller.pointList['2']!.map((point) {
                                return Expanded(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          controller.onChangePoint("$point");
                                          controller.onClickPointList(point);
                                        },
                                        child: Container(
                                          margin: EdgeInsets.only(
                                            left: point == 10000 ? 0 : 8,
                                          ),
                                          alignment: Alignment.center,
                                          width: double.infinity,
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 8,
                                            horizontal: 8,
                                          ),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              width: 1,
                                              color: controller
                                                          .selectedPointList ==
                                                      point
                                                  ? AppColors.primary
                                                  : AppColors.inputBorder,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Column(
                                            children: [
                                              Text(
                                                CommonFn.parseMoney(point),
                                              ),
                                              Text(
                                                AppLocale.point
                                                    .getString(context),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        "${CommonFn.parseMoney(point * controller.pointRaio)} ${AppLocale.lak.getString(context)}",
                                        style: const TextStyle(
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                        top: 8,
                        left: 16,
                        right: 16,
                        bottom: 16,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border(
                          bottom: BorderSide(
                            width: 0.5,
                            color: AppColors.inputBorder,
                          ),
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        AppLocale.or.getString(context),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(16),
                      color: Colors.white,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                AppLocale.pointsToBuy.getString(context),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: InputText(
                                  disabled: controller.isLoadingPoint,
                                  controller: controller.pointInpuController,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.end,
                                  onChanged: controller.onChangePoint,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                AppLocale.point.getString(context),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(AppLocale.totalAmountForPay
                                  .getString(context)),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Builder(builder: (context) {
                                final pointWantToBuy =
                                    controller.pointWantToBuy;
                                int money = 0;
                                if (pointWantToBuy != null) {
                                  money = pointWantToBuy * controller.pointRaio;
                                }
                                return Text(
                                  "${CommonFn.parseMoney(money)} ${AppLocale.lak.getString(context)}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                );
                              }),
                            ],
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () {
                        // controller.gotoSelectPaymentMethod();
                        controller.gotoPaymentMethod();
                      },
                      child: Container(
                        padding: const EdgeInsets.only(
                          left: 16,
                          right: 16,
                          top: 16,
                          bottom: 16,
                        ),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              AppLocale.paymentMethod.getString(context),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Builder(
                                  builder: (context) {
                                    final selectedBank =
                                        controller.selectedBank;
                                    if (selectedBank == null) {
                                      return Expanded(
                                        child: Text(
                                          AppLocale.pleaseSelectPaymentMethod
                                              .getString(context),
                                          style: const TextStyle(
                                            color: AppColors.disableText,
                                          ),
                                        ),
                                      );
                                    } else {
                                      return Expanded(
                                        child: Row(
                                          children: [
                                            CachedNetworkImage(
                                              imageUrl: selectedBank.logo ?? '',
                                              width: 42,
                                              height: 42,
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              selectedBank.fullName,
                                            ),
                                            // if (controller.disableBank(
                                            //     selectedBank)) ...[
                                            //   const SizedBox(width: 8),
                                            //   const Icon(
                                            //     Icons.info,
                                            //     color: Colors.red,
                                            //   ),
                                            // ]
                                          ],
                                        ),
                                      );
                                    }
                                  },
                                ),
                                SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: SvgPicture.asset(AppIcon.arrowRight),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [AppTheme.softShadow],
                ),
                child: Obx(() {
                  bool disabled = controller.selectedBank == null ||
                      controller.isLoadingPoint;
                  if (controller.pointWantToBuy == null) {
                    disabled = true;
                  }
                  return LongButton(
                    disabled: disabled,
                    isLoading: controller.isLoading.value,
                    onPressed: () {
                      controller.submitBuyPoint();
                    },
                    child: Text(
                      AppLocale.pay.getString(context),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      );
    });
  }
}
