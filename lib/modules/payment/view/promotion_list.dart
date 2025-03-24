import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/components/checkbox.dart';
import 'package:lottery_ck/components/header.dart';
import 'package:lottery_ck/components/long_button.dart';
import 'package:lottery_ck/modules/payment/controller/payment.controller.dart';
import 'package:lottery_ck/res/app_locale.dart';
import 'package:lottery_ck/res/color.dart';
import 'package:lottery_ck/res/icon.dart';
import 'package:lottery_ck/utils.dart';
import 'package:lottery_ck/utils/common_fn.dart';
import 'package:lottery_ck/utils/theme.dart';

class PromotionListPage extends StatefulWidget {
  final List<Map> promotionList;
  final List? selectedPromotionIds;
  const PromotionListPage({
    super.key,
    required this.promotionList,
    this.selectedPromotionIds,
  });

  @override
  State<PromotionListPage> createState() => _PromotionListPageState();
}

class _PromotionListPageState extends State<PromotionListPage> {
  String? selectedPromotionId;
  bool isLoading = false;

  void setup() {
    logger.w(widget.selectedPromotionIds);
    if (widget.selectedPromotionIds != null) {
      if (widget.selectedPromotionIds?.isNotEmpty == true) {
        setState(() {
          selectedPromotionId = widget.selectedPromotionIds?.first;
        });
      }
    }
  }

  void setIsLoading(bool value) {
    setState(() {
      isLoading = value;
    });
  }

  Future<void> onSubmit() async {
    try {
      if (selectedPromotionId == null) {
        return;
      }
      setIsLoading(true);
      final isSuccess =
          await PaymentController.to.applyPromotion(selectedPromotionId!);
      if (isSuccess) {
        Future.delayed(const Duration(milliseconds: 250), () {
          Get.back();
        });
      }
    } catch (e) {
      logger.e("$e");
    } finally {
      setIsLoading(false);
    }
  }

  void showPromotion(BuildContext context, Map promotion) {
    PaymentController.to.showPromotionDetail(context, promotion);
  }

  void onClickPromotion(Map? promotion) {
    logger.w(promotion);
    if (promotion == null) {
      setState(() {
        selectedPromotionId = null;
      });
      return;
    }
    setState(() {
      selectedPromotionId = promotion["\$id"];
    });
  }

  @override
  void initState() {
    setup();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Header(
              title: AppLocale.promotion.getString(context),
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
                      if (widget.promotionList.isEmpty) {
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
                        children: widget.promotionList.map((promotion) {
                          // logger.w("coupon: ${coupon.couponId}");
                          // final promotion = coupon.promotion;
                          final int currentUse = promotion['current_use'] ?? 0;
                          final int maxUser = promotion['max_user'] ?? 0;
                          final leftPercent =
                              maxUser == 0 ? 0 : currentUse / maxUser;
                          final percentStr = leftPercent * 100;
                          return GestureDetector(
                            onTap: () {
                              if (leftPercent >= 1) {
                                return;
                              }
                              onClickPromotion(promotion);
                              // onClickCoupon(coupon.couponId);
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
                                                "${promotion['name'] ?? "Not found promotion"}",
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                ),
                                              ),
                                              // const SizedBox(height: 8),
                                              // Text(
                                              //   "${coupon.promotion?['detail'] ?? "Not found promotion"}",
                                              //   maxLines: 2,
                                              //   style: const TextStyle(
                                              //     fontSize: 14,
                                              //   ),
                                              // ),
                                              Builder(
                                                builder: (context) {
                                                  if (promotion['max_user'] ==
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
                                                  if (promotion['end_date'] ==
                                                      null) {
                                                    return const SizedBox
                                                        .shrink();
                                                  }
                                                  // if (coupon.expireDate ==
                                                  //     null) {
                                                  //   return const SizedBox
                                                  //       .shrink();
                                                  // }
                                                  final expireDate =
                                                      DateTime.parse(promotion[
                                                          'end_date']);
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
                                                              "${AppLocale.validUntil.getString(context)} ${CommonFn.parseDMY(expireDate)} ${CommonFn.parseHM(expireDate)}",
                                                              // "asd",
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
                                                              // TODO: show promotion detail
                                                              showPromotion(
                                                                  context,
                                                                  promotion);
                                                            },
                                                            child: Container(
                                                              child: Text(
                                                                AppLocale
                                                                    .readMore
                                                                    .getString(
                                                                        context),
                                                                style:
                                                                    TextStyle(
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
                                        // TODO: fix use value
                                        value: selectedPromotionId ==
                                            promotion['\$id'],
                                        onChange: (value) {
                                          // TODO: fix use function
                                          logger.d("value: $value");
                                          // onClickCoupon(coupon.couponId);
                                          if (value) {
                                            onClickPromotion(promotion);
                                            return;
                                          }
                                          onClickPromotion(null);
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
                                      //         style: const TextStyle(
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
                disabled: selectedPromotionId == null,
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
