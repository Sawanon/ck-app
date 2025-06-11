import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottery_ck/modules/layout/controller/layout.controller.dart';
import 'package:lottery_ck/modules/notification/controller/notification.controller.dart';
import 'package:lottery_ck/res/app_locale.dart';
import 'package:lottery_ck/storage.dart';
import 'package:lottery_ck/utils.dart';

class DialogPromotion extends StatefulWidget {
  final List promotionList;
  const DialogPromotion({
    super.key,
    required this.promotionList,
  });

  @override
  State<DialogPromotion> createState() => _DialogPromotionState();
}

class _DialogPromotionState extends State<DialogPromotion> {
  int _currentPage = 0;
  bool doNotShow = false;

  void changeNotShowMessage(bool value) async {
    if (value) {
      await StorageController.to.setPromotionLater();
    } else {
      await StorageController.to.removePromotionLater();
    }
    setState(() {
      doNotShow = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: double.infinity,
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CarouselSlider(
                    items: widget.promotionList.map((promotion) {
                      logger.d(promotion);
                      final imageUrl = (promotion['banner_image'] == null ||
                              promotion['banner_image'] == "")
                          ? 'https://www.google.com'
                          : promotion['banner_image'];
                      return GestureDetector(
                        onTap: () {
                          Get.back();
                          // LayoutController.to.changeTab(TabApp.notifications);
                          final promotionId = promotion['\$id'];
                          NotificationController.to
                              .openPromotionDetail(promotionId);
                        },
                        // child: Text(imageUrl),
                        child: CachedNetworkImage(
                          imageUrl: imageUrl,
                          errorWidget: (context, url, error) {
                            return Container(
                              alignment: Alignment.center,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.image,
                                    size: 64,
                                  ),
                                  Text(
                                    "Image not found",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      );
                    }).toList(),
                    options: CarouselOptions(
                      height: 242.0,
                      viewportFraction: 1,
                      autoPlay: true,
                      autoPlayInterval: const Duration(
                        seconds: 5,
                      ),
                      onPageChanged: (index, reason) {
                        setState(() {
                          _currentPage = index;
                        });
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: widget.promotionList.asMap().entries.map((entry) {
                      return Container(
                        width: 12,
                        height: 12,
                        margin: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: entry.key == _currentPage
                              ? Colors.grey.shade600
                              : Colors.grey.shade400,
                        ),
                      );
                    }).toList(),
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 16,
                        height: 16,
                        child: Checkbox(
                          value: doNotShow,
                          shape: CircleBorder(
                            side: BorderSide(
                              width: 1,
                              color: Colors.blueGrey,
                            ),
                          ),
                          onChanged: (value) {
                            logger.d(value);
                            if (value == null) return;
                            changeNotShowMessage(value);
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        AppLocale.doNotShowThisMessageAgain.getString(context),
                      ),
                    ],
                  ),
                ],
              ),
              Positioned(
                top: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () => Get.back(),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey.shade600,
                    ),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
