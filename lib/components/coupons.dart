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
  Map<String, bool?> selectedCoupon = {};

  void setIsLoading(bool value) {
    setState(() {
      isLoading = value;
    });
  }

  void onClickCoupon(String couponId) {
    final _selectedCoupon = selectedCoupon[couponId];
    if (_selectedCoupon == null || _selectedCoupon == false) {
      setState(() {
        selectedCoupon[couponId] = true;
      });
    } else {
      setState(() {
        selectedCoupon[couponId] = false;
      });
    }
  }

  void onSubmit() async {
    logger.d(selectedCoupon);
    final List<String> couponIdsList = [];
    selectedCoupon.forEach(
      (key, value) {
        logger.d("key: $key");
        logger.d("value: $value");
        if (value == true) {
          couponIdsList.add(key);
        }
      },
    );
    logger.d(couponIdsList);
    setIsLoading(true);
    await PaymentController.to.applyCoupon(couponIdsList);
    setIsLoading(false);
    Get.back();
  }

  void setup() {
    if (widget.selectedCouponsList != null) {
      Map<String, bool?> _selectedCoupon = {};
      for (var coupon in widget.selectedCouponsList!) {
        _selectedCoupon[coupon] = true;
      }
      setState(() {
        selectedCoupon = _selectedCoupon;
      });
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
                children: widget.couponsList.map((coupon) {
                  return GestureDetector(
                    onTap: () {
                      onClickCoupon(coupon.couponId);
                    },
                    child: Container(
                      margin: EdgeInsets.only(
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
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Container(
                              width: 80,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
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
                                padding: EdgeInsets.only(
                                  left: 12,
                                  top: 16,
                                  bottom: 16,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${coupon.promotion?['name'] ?? "Not found promotion"}",
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      "${coupon.promotion?['detail'] ?? "Not found promotion"}",
                                      style: TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            CheckboxComponent(
                              value: selectedCoupon[coupon.couponId] == true,
                              onChange: (value) {
                                logger.d("value: $value");
                              },
                            ),
                            const SizedBox(width: 16),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: LongButton(
                isLoading: isLoading,
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
