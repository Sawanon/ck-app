import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottery_ck/components/checkbox.dart';
import 'package:lottery_ck/components/dialog.dart';
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
    if (selectedCouponId == null) {
      return;
    }
    final point = PaymentController.to.point;
    logger.w("point: $point");
    // if (point != null && point != 0) {
    //   Get.dialog(
    //     DialogApp(
    //       title: Text(
    //         AppLocale.recalculateScores.getString(context),
    //         style: TextStyle(
    //           fontSize: 16,
    //           fontWeight: FontWeight.bold,
    //         ),
    //       ),
    //       details: Text(
    //         AppLocale.recalculateScoresDetail.getString(context),
    //       ),
    //       onConfirm: () async {
    //         await applyCoupon();
    //         PaymentController.to.applyPoint(0, false);
    //         Get.back();
    //       },
    //     ),
    //   );
    //   return;
    // }
    await applyCoupon();
  }

  Future<void> applyCoupon() async {
    setIsLoading(true);
    await PaymentController.to.applyCoupon([selectedCouponId!]);
    setIsLoading(false);
    Future.delayed(const Duration(milliseconds: 250), () {
      Get.back();
    });
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

  void showCoupon(BuildContext context, Coupon coupon) {
    PaymentController.to.showCouponDetailInCouponPage(context, coupon);
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
                                style: TextStyle(
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
                          logger.w("coupon: ${coupon.couponId}");
                          final promotion = coupon.promotion;
                          final int currentUse = promotion?['current_use'] ?? 0;
                          final int maxUser = promotion?['max_user'] ?? 0;
                          final leftPercent =
                              maxUser == 0 ? 0 : currentUse / maxUser;
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
                                        width: 60,
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
                                            right: 12,
                                            top: 16,
                                            bottom: 16,
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "${coupon.promotion?['name'] ?? "Not found promotion"}",
                                                style: TextStyle(
                                                  fontSize: 16,
                                                ),
                                              ),
                                              // const SizedBox(height: 8),
                                              // Text(
                                              //   "${coupon.promotion?['detail'] ?? "Not found promotion"}",
                                              //   maxLines: 2,
                                              //   style: TextStyle(
                                              //     fontSize: 14,
                                              //   ),
                                              // ),
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
                                                        style: TextStyle(
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
                                                      Row(
                                                        children: [
                                                          Expanded(
                                                            child: Text(
                                                              "${AppLocale.validUntil.getString(context)} ${CommonFn.parseDMY(expireDate)} ${CommonFn.parseHMS(expireDate)}",
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 12,
                                                                color: AppColors
                                                                    .textPrimary,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                              ),
                                                            ),
                                                          ),
                                                          GestureDetector(
                                                            onTap: () {
                                                              showCoupon(
                                                                  context,
                                                                  coupon);
                                                            },
                                                            child: Container(
                                                              child: Text(
                                                                AppLocale
                                                                    .readMore
                                                                    .getString(
                                                                        context),
                                                                style:
                                                                    GoogleFonts
                                                                        .prompt(
                                                                  fontSize: 12,
                                                                  color: Colors
                                                                      .blue
                                                                      .shade600,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
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
                                          // logger.d("value: $value");
                                          onClickCoupon(coupon.couponId);
                                        },
                                      ),
                                      const SizedBox(width: 16),
                                      // Column(
                                      //   mainAxisAlignment:
                                      //       MainAxisAlignment.center,
                                      //   mainAxisSize: MainAxisSize.min,
                                      //   children: [
                                      //     Container(
                                      //       margin: EdgeInsets.only(
                                      //         bottom: 12,
                                      //         right: 12,
                                      //       ),
                                      //       padding: const EdgeInsets.symmetric(
                                      //         vertical: 12,
                                      //       ),
                                      //       width: 80,
                                      //       alignment: Alignment.center,
                                      //       decoration: BoxDecoration(
                                      //         color: AppColors.primary,
                                      //         borderRadius:
                                      //             BorderRadius.circular(8),
                                      //       ),
                                      //       child: Text(
                                      //         AppLocale.apply
                                      //             .getString(context),
                                      //         style: TextStyle(
                                      //           color: Colors.white,
                                      //         ),
                                      //       ),
                                      //     ),
                                      //   ],
                                      // ),
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
