import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/components/checkbox.dart';
import 'package:lottery_ck/components/header.dart';
import 'package:lottery_ck/components/long_button.dart';
import 'package:lottery_ck/model/coupon.dart';
import 'package:lottery_ck/modules/payment/controller/payment.controller.dart';
import 'package:lottery_ck/res/app_locale.dart';
import 'package:lottery_ck/res/color.dart';
import 'package:lottery_ck/res/icon.dart';
import 'package:lottery_ck/utils.dart';
import 'package:lottery_ck/utils/common_fn.dart';
import 'package:lottery_ck/utils/theme.dart';

class CouponsPage extends StatefulWidget {
  final List<Coupon> couponsList;
  final List? selectedCouponsList;
  const CouponsPage({
    super.key,
    required this.couponsList,
    this.selectedCouponsList,
  });

  @override
  State<CouponsPage> createState() => _CouponsPageState();
}

class _CouponsPageState extends State<CouponsPage> {
  bool isLoading = false;
  // Map<String, bool?> selectedCoupon = {};
  String? selectedCouponId;

  void setIsLoading(bool value) {
    setState(() {
      isLoading = value;
    });
  }

  void onClickCoupon(String couponId) {
    setState(() {
      selectedCouponId = couponId;
    });
    // final _selectedCoupon = selectedCoupon[couponId];
    // if (_selectedCoupon == null || _selectedCoupon == false) {
    //   setState(() {
    //     selectedCoupon[couponId] = true;
    //   });
    // } else {
    //   setState(() {
    //     selectedCoupon[couponId] = false;
    //   });
    // }
  }

  void onSubmit() async {
    // logger.d(selectedCoupon);
    // final List<String> couponIdsList = [];
    // selectedCoupon.forEach(
    //   (key, value) {
    //     logger.d("key: $key");
    //     logger.d("value: $value");
    //     if (value == true) {
    //       couponIdsList.add(key);
    //     }
    //   },
    // );
    // logger.d(couponIdsList);
    if (selectedCouponId == null) {
      return;
    }
    setIsLoading(true);
    await PaymentController.to.applyCoupon([selectedCouponId!]);
    setIsLoading(false);
    Get.back();
  }

  void setup() {
    if (widget.selectedCouponsList != null) {
      // Map<String, bool?> _selectedCoupon = {};
      // for (var coupon in widget.selectedCouponsList!) {
      //   _selectedCoupon[coupon] = true;
      // }
      if (widget.selectedCouponsList?.isNotEmpty == true) {
        setState(() {
          // selectedCoupon = _selectedCoupon;
          selectedCouponId = widget.selectedCouponsList?.first;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    setup();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Header(
              title: AppLocale.coupon.getString(context),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                children: [
                  Builder(
                    builder: (context) {
                      if (widget.couponsList.isEmpty) {
                        return Container(
                          alignment: Alignment.center,
                          height: MediaQuery.of(context).size.height / 2,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: 120,
                                height: 120,
                                child: SvgPicture.asset(
                                  AppIcon.promotionBold,
                                  colorFilter: const ColorFilter.mode(
                                    AppColors.disableText,
                                    BlendMode.srcIn,
                                  ),
                                ),
                              ),
                              Text(
                                AppLocale.youDontHaveCoupon.getString(context),
                                style: const TextStyle(
                                  color: AppColors.disableText,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: widget.couponsList.map((coupon) {
                          final promotion = coupon.promotion;
                          logger.w(promotion);
                          final int currentUse = promotion?['current_use'];
                          final int maxUser = promotion?['max_user'];
                          final leftPercent = currentUse / maxUser;
                          final percentStr = leftPercent * 100;
                          return GestureDetector(
                            onTap: () {
                              if (leftPercent >= 1) {
                                return;
                              }
                              onClickCoupon(coupon.couponId);
                            },
                            child: Opacity(
                              opacity: leftPercent >= 1 ? 0.4 : 1,
                              child: Container(
                                margin: const EdgeInsets.only(
                                  top: 8,
                                ),
                                clipBehavior: Clip.hardEdge,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: const [AppTheme.softShadow],
                                ),
                                child: IntrinsicHeight(
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Container(
                                        width: 80,
                                        alignment: Alignment.center,
                                        decoration: const BoxDecoration(
                                          color: AppColors.primary,
                                        ),
                                        child: SizedBox(
                                          width: 48,
                                          height: 48,
                                          child: SvgPicture.asset(
                                            AppIcon.promotionBold,
                                            colorFilter: const ColorFilter.mode(
                                              Colors.white,
                                              BlendMode.srcIn,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          padding: const EdgeInsets.only(
                                            left: 12,
                                            right: 16,
                                            top: 16,
                                            bottom: 16,
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "${coupon.promotion?['name'] ?? "Not found promotion"}",
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              Text(
                                                "${coupon.promotion?['detail'] ?? "Not found promotion"}",
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                ),
                                              ),
                                              Builder(
                                                builder: (context) {
                                                  if (promotion == null ||
                                                      promotion['max_user'] ==
                                                          null) {
                                                    return const SizedBox
                                                        .shrink();
                                                  }

                                                  return Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      const SizedBox(height: 4),
                                                      Container(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        width: double.infinity,
                                                        height: 6,
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(24),
                                                          color: Colors
                                                              .grey.shade300,
                                                        ),
                                                        child: LayoutBuilder(
                                                          builder: (context,
                                                              constraints) {
                                                            double outerWidth =
                                                                constraints
                                                                    .maxWidth;
                                                            logger
                                                                .w(outerWidth);
                                                            return Container(
                                                              width: outerWidth *
                                                                  leftPercent,
                                                              // margin:
                                                              //     const EdgeInsets
                                                              //         .only(
                                                              //   right: 24,
                                                              // ),
                                                              height: 6,
                                                              decoration:
                                                                  BoxDecoration(
                                                                // gradient: AppColors
                                                                //     .primayBtn,
                                                                gradient:
                                                                    LinearGradient(
                                                                  colors: [
                                                                    AppColors
                                                                        .redGradient,
                                                                    AppColors
                                                                        .yellowGradient,
                                                                  ],
                                                                ),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            24),
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                      const SizedBox(height: 8),
                                                      Text(
                                                        "${AppLocale.used.getString(context)} ${percentStr.toStringAsFixed(0)}%",
                                                        style: const TextStyle(
                                                          fontSize: 12,
                                                          color: AppColors
                                                              .textPrimary,
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              ),
                                              Builder(
                                                builder: (context) {
                                                  if (coupon.expireDate ==
                                                      null) {
                                                    return const SizedBox
                                                        .shrink();
                                                  }
                                                  final expireDate =
                                                      coupon.expireDate!;
                                                  return Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      const SizedBox(height: 8),
                                                      Text(
                                                        "${AppLocale.validUntil.getString(context)} ${CommonFn.parseDMY(expireDate)} ${CommonFn.parseHMS(expireDate)}",
                                                        style: const TextStyle(
                                                          fontSize: 12,
                                                          color: AppColors
                                                              .textPrimary,
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      CheckboxComponent(
                                        value:
                                            selectedCouponId == coupon.couponId,
                                        onChange: (value) {
                                          logger.d("value: $value");
                                        },
                                      ),
                                      const SizedBox(width: 16),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: LongButton(
                isLoading: isLoading,
                disabled: selectedCouponId == null,
                onPressed: () {
                  onSubmit();
                },
                child: Text(
                  AppLocale.confirm.getString(context),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
