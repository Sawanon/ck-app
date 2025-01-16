import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottery_ck/components/banner.dart';
import 'package:lottery_ck/components/dev/dialog_change_url.dart';
import 'package:lottery_ck/components/friends.dart';
import 'package:lottery_ck/components/input_text.dart';
import 'package:lottery_ck/components/menu_card.dart';
import 'package:lottery_ck/components/menu_grid.dart';
import 'package:lottery_ck/modules/home/controller/home.controller.dart';
import 'package:lottery_ck/modules/setting/controller/setting.controller.dart';
import 'package:lottery_ck/res/app_locale.dart';
import 'package:lottery_ck/res/color.dart';
import 'package:lottery_ck/res/icon.dart';
import 'package:lottery_ck/route/route_name.dart';
import 'package:lottery_ck/storage.dart';
import 'package:lottery_ck/utils.dart';
import 'package:lottery_ck/utils/common_fn.dart';
import 'package:lottery_ck/utils/theme.dart';

class HomePageV2 extends StatelessWidget {
  const HomePageV2({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(builder: (controller) {
      return RefreshIndicator(
        onRefresh: () async {
          controller.setup();
        },
        child: Scaffold(
          body: Stack(
            fit: StackFit.expand,
            children: [
              // Align(
              //   alignment: Alignment.topCenter,
              //   child: Container(
              //     clipBehavior: Clip.hardEdge,
              //     width: double.infinity,
              //     height: 200,
              //     decoration: BoxDecoration(
              //       color: Colors.red.shade100,
              //       borderRadius: BorderRadius.only(
              //         bottomLeft: Radius.circular(64),
              //         bottomRight: Radius.circular(64),
              //       ),
              //     ),
              //     child: Obx(() {
              //       return CachedNetworkImage(
              //         color: Colors.black.withOpacity(0.2),
              //         colorBlendMode: BlendMode.darken,
              //         fit: BoxFit.fitWidth,
              //         imageUrl: controller.wallpaperUrl.value != ''
              //             ? controller.wallpaperUrl.value
              //             : 'https://baas.moevedigital.com/v1/storage/buckets/66fa748a001a67ac8a70/files/67613b9300325a54f182/view?project=667afb24000fbd66b4df',
              //       );
              //     }),
              //     // child: CachedNetworkImage(
              //     //   color: Colors.black.withOpacity(0.2),
              //     //   colorBlendMode: BlendMode.darken,
              //     //   fit: BoxFit.fitWidth,
              //     //   imageUrl:
              //     //       'https://baas.moevedigital.com/v1/storage/buckets/66fa748a001a67ac8a70/files/67613b9300325a54f182/view?project=667afb24000fbd66b4df',
              //     // ),
              //   ),
              // ),
              SafeArea(
                top: false,
                child: ListView(
                  clipBehavior: Clip.none,
                  padding: const EdgeInsets.all(0),
                  physics: AlwaysScrollableScrollPhysics(),
                  children: [
                    Stack(
                      children: [
                        Align(
                          alignment: Alignment.topCenter,
                          child: Container(
                            clipBehavior: Clip.hardEdge,
                            width: double.infinity,
                            height: 200,
                            decoration: BoxDecoration(
                              color: Colors.red.shade100,
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(64),
                                bottomRight: Radius.circular(64),
                              ),
                            ),
                            child: Obx(() {
                              return CachedNetworkImage(
                                color: Colors.black.withOpacity(0.2),
                                colorBlendMode: BlendMode.darken,
                                fit: BoxFit.fitWidth,
                                imageUrl: controller.wallpaperUrl.value != ''
                                    ? controller.wallpaperUrl.value
                                    : 'https://baas.moevedigital.com/v1/storage/buckets/66fa748a001a67ac8a70/files/67613b9300325a54f182/view?project=667afb24000fbd66b4df',
                              );
                            }),
                            // child: CachedNetworkImage(
                            //   color: Colors.black.withOpacity(0.2),
                            //   colorBlendMode: BlendMode.darken,
                            //   fit: BoxFit.fitWidth,
                            //   imageUrl:
                            //       'https://baas.moevedigital.com/v1/storage/buckets/66fa748a001a67ac8a70/files/67613b9300325a54f182/view?project=667afb24000fbd66b4df',
                            // ),
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 36),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24.0),
                              child: Text(
                                AppLocale.hello.getString(context),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onDoubleTap: () {
                                logger.d("message");
                                Get.dialog(
                                  DialogChangeUrl(),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24.0),
                                child: Text(
                                  AppLocale.welcome.getString(context),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24.0),
                              child: Container(
                                padding: const EdgeInsets.all(14),
                                // padding: const EdgeInsets.symmetric(
                                //   vertical: 18,
                                //   horizontal: 18,
                                // ),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(24),
                                    boxShadow: const [
                                      AppTheme.softShadow,
                                    ]),
                                child: Stack(
                                  children: [
                                    Column(
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Obx(() {
                                              return Container(
                                                clipBehavior: Clip.hardEdge,
                                                width: 48,
                                                height: 48,
                                                decoration: const BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Colors.white,
                                                    boxShadow: [
                                                      AppTheme.softShadow,
                                                    ]),
                                                child: SettingController
                                                            .to
                                                            .profileByte
                                                            .value ==
                                                        null
                                                    ? const Icon(Icons.person)
                                                    : Image.memory(
                                                        SettingController.to
                                                            .profileByte.value!,
                                                        fit: BoxFit.cover,
                                                      ),
                                              );
                                            }),
                                            const SizedBox(width: 16),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  SettingController
                                                          .to.user?.firstName ??
                                                      AppLocale.firstName
                                                          .getString(context),
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Text(
                                                  CommonFn.hidePhoneNumber(
                                                    SettingController.to.user
                                                            ?.phoneNumber ??
                                                        "+856XXXXXXXXXX",
                                                  ),
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: GestureDetector(
                                                onTap: () {
                                                  // Get.toNamed(
                                                  //     RouteName.friends);
                                                  if (controller.myFriends !=
                                                      null) {
                                                    Get.to(
                                                      () => FriendsPage(
                                                        myFriends: controller
                                                            .myFriends!,
                                                        // listMyFriends:
                                                        //     controller
                                                        //         .listMyFriends,
                                                      ),
                                                    );
                                                  }
                                                },
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.only(
                                                    top: 4,
                                                    bottom: 4,
                                                    left: 6,
                                                    right: 0,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                    gradient:
                                                        const LinearGradient(
                                                      colors: [
                                                        Color.fromRGBO(
                                                            225, 126, 61, 1),
                                                        Color.fromRGBO(
                                                            235, 157, 100, 1),
                                                        Color.fromRGBO(
                                                            235, 157, 100, 1),
                                                        Color.fromRGBO(
                                                            225, 126, 61, 1),
                                                      ],
                                                      begin:
                                                          Alignment.centerLeft,
                                                      end:
                                                          Alignment.centerRight,
                                                      stops: [
                                                        0,
                                                        0.28,
                                                        0.72,
                                                        1,
                                                      ],
                                                    ),
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Container(
                                                        padding:
                                                            EdgeInsets.all(1),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: const Color
                                                              .fromRGBO(
                                                              226, 129, 65, 1),
                                                          shape:
                                                              BoxShape.circle,
                                                          border: Border.all(
                                                            color: Colors.white,
                                                            width: 1,
                                                          ),
                                                        ),
                                                        child: Container(
                                                          width: 29,
                                                          height: 29,
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                            right: 5,
                                                          ),
                                                          alignment: Alignment
                                                              .centerRight,
                                                          decoration:
                                                              const BoxDecoration(
                                                            color: Colors.white,
                                                            shape:
                                                                BoxShape.circle,
                                                          ),
                                                          child: SizedBox(
                                                            width: 17,
                                                            height: 17,
                                                            child: SvgPicture
                                                                .asset(
                                                              AppIcon.groupAdd,
                                                              colorFilter:
                                                                  ColorFilter
                                                                      .mode(
                                                                Color.fromRGBO(
                                                                    226,
                                                                    130,
                                                                    67,
                                                                    1),
                                                                BlendMode.srcIn,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 30,
                                                        child: Text(
                                                          AppLocale
                                                              .inviteFriends
                                                              .getString(
                                                                  context),
                                                          style: TextStyle(
                                                            fontSize: 10,
                                                          ),
                                                          softWrap: true,
                                                        ),
                                                      ),
                                                      // Column(
                                                      //   children: [
                                                      //     Text(
                                                      //       "แนะนำ",
                                                      //       style: GoogleFonts
                                                      //           .prompt(
                                                      //         textStyle:
                                                      //             TextStyle(
                                                      //           fontSize: 10,
                                                      //           fontWeight:
                                                      //               FontWeight
                                                      //                   .w500,
                                                      //         ),
                                                      //       ),
                                                      //       // style: TextStyle(
                                                      //       //   fontSize: 10,
                                                      //       //   fontWeight: FontWeight.w500,
                                                      //       // ),
                                                      //     ),
                                                      //     Text(
                                                      //       "เพื่อน",
                                                      //       style: GoogleFonts
                                                      //           .prompt(
                                                      //         textStyle:
                                                      //             TextStyle(
                                                      //           fontSize: 10,
                                                      //           fontWeight:
                                                      //               FontWeight
                                                      //                   .w500,
                                                      //         ),
                                                      //       ),
                                                      //     ),
                                                      //   ],
                                                      // ),
                                                      Column(
                                                        children: [
                                                          Text(
                                                            AppLocale
                                                                .inviteAccept
                                                                .getString(
                                                                    context),
                                                            style: GoogleFonts
                                                                .prompt(
                                                              textStyle:
                                                                  TextStyle(
                                                                fontSize: 10,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                            ),
                                                          ),
                                                          if (controller
                                                                  .myFriends ==
                                                              null)
                                                            Text(
                                                              "0/0",
                                                              style: TextStyle(
                                                                fontSize: 13,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                height: 1.1,
                                                              ),
                                                            )
                                                          else
                                                            Text(
                                                              // TODO: continute dev share friend
                                                              "${controller.myFriends!.total}/${controller.myFriends!.accepted}",
                                                              style: TextStyle(
                                                                fontSize: 13,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                height: 1.1,
                                                              ),
                                                            ),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        width: 16,
                                                        height: 16,
                                                        child: SvgPicture.asset(
                                                          AppIcon.arrowRight,
                                                          colorFilter:
                                                              ColorFilter.mode(
                                                            Colors.white,
                                                            BlendMode.srcIn,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 5),
                                            Expanded(
                                              child: GestureDetector(
                                                onTap: () {
                                                  Get.toNamed(RouteName.point);
                                                },
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.only(
                                                    top: 4,
                                                    bottom: 4,
                                                    left: 6,
                                                    right: 0,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    gradient: LinearGradient(
                                                      colors: [
                                                        Color.fromRGBO(
                                                            33, 165, 81, 1),
                                                        Color.fromRGBO(
                                                                33, 165, 81, 1)
                                                            .withOpacity(0.5),
                                                        Color.fromRGBO(
                                                                33, 165, 81, 1)
                                                            .withOpacity(0.8),
                                                      ],
                                                      begin:
                                                          Alignment.centerLeft,
                                                      end:
                                                          Alignment.centerRight,
                                                      stops: const [
                                                        0,
                                                        0.53,
                                                        1,
                                                      ],
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Container(
                                                        padding:
                                                            EdgeInsets.all(1),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Color.fromRGBO(
                                                              33, 165, 81, 1),
                                                          shape:
                                                              BoxShape.circle,
                                                          border: Border.all(
                                                            color: Colors.white,
                                                            width: 1,
                                                          ),
                                                        ),
                                                        child: Container(
                                                          width: 29,
                                                          height: 29,
                                                          alignment:
                                                              Alignment.center,
                                                          decoration:
                                                              const BoxDecoration(
                                                            color: Colors.white,
                                                            shape:
                                                                BoxShape.circle,
                                                          ),
                                                          child: Text(
                                                            "P",
                                                            style: TextStyle(
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: Color
                                                                  .fromRGBO(
                                                                      33,
                                                                      165,
                                                                      81,
                                                                      1),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Column(
                                                        children: [
                                                          Text(
                                                            AppLocale
                                                                .youHaveScore
                                                                .getString(
                                                                    context),
                                                            style: TextStyle(
                                                              fontSize: 12,
                                                              color:
                                                                  Colors.white,
                                                              height: 1,
                                                            ),
                                                          ),
                                                          Text(
                                                            SettingController
                                                                        .to
                                                                        .user
                                                                        ?.point !=
                                                                    null
                                                                ? CommonFn.parseMoney(
                                                                    SettingController
                                                                        .to
                                                                        .user!
                                                                        .point)
                                                                : '100,000',
                                                            style: TextStyle(
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        width: 16,
                                                        height: 16,
                                                        child: SvgPicture.asset(
                                                          AppIcon.arrowRight,
                                                          colorFilter:
                                                              ColorFilter.mode(
                                                            Colors.white,
                                                            BlendMode.srcIn,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 12),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "0.00 กีบ",
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      height: 1,
                                                      color: Color.fromRGBO(
                                                          229, 229, 229, 1),
                                                    ),
                                                  ),
                                                  Text(
                                                    AppLocale.amountInWallet
                                                        .getString(context),
                                                    style: TextStyle(
                                                      height: 1,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 12,
                                                      color: Color.fromRGBO(
                                                          229, 229, 229, 1),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              child: Align(
                                                alignment:
                                                    Alignment.centerRight,
                                                child: GestureDetector(
                                                  onTap: () {
                                                    controller.gotoBuyLottery();
                                                  },
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                      gradient:
                                                          AppColors.primayBtn,
                                                    ),
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                      vertical: 6,
                                                      horizontal: 32,
                                                    ),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          AppLocale.buyLottery
                                                              .getString(
                                                                  context),
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    if (SettingController.to.user == null)
                                      Positioned(
                                        top: 0,
                                        left: 0,
                                        right: 0,
                                        bottom: 0,
                                        child: Container(
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                Colors.white.withOpacity(0.6),
                                                Colors.white,
                                              ],
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                            ),
                                          ),
                                          child: GestureDetector(
                                            onTap: () {
                                              Get.toNamed(RouteName.login);
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.only(
                                                top: 12,
                                                bottom: 12,
                                                left: 16,
                                                right: 24,
                                              ),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                gradient: AppColors.primayBtn,
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  const Icon(
                                                    Icons.lock_open_rounded,
                                                    color: Colors.white,
                                                  ),
                                                  const SizedBox(width: 12),
                                                  Text(
                                                    AppLocale.login
                                                        .getString(context),
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Obx(
                        () {
                          // CarouselSlider
                          if (controller.bannerContent.value.isEmpty) {
                            return Container(
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.white,
                                boxShadow: const [
                                  AppTheme.softShadow,
                                ],
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    clipBehavior: Clip.hardEdge,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                    ),
                                    child: Image.asset(
                                      "assets/icon/ck-lotto.jpg",
                                      width: 52,
                                      height: 52,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Image.asset(
                                      "assets/ck-w3.png",
                                      fit: BoxFit.fitHeight,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                          return BannerComponent(
                            // items: [
                            //   "https://baas.moevedigital.com/v1/storage/buckets/news_image/files/66d532000003e376a41c/view?project=667afb24000fbd66b4df&mode=admin",
                            //   "https://baas.moevedigital.com/v1/storage/buckets/news_image/files/66d54346001938c02f20/view?project=667afb24000fbd66b4df&mode=admin",
                            // ]
                            items:
                                controller.bannerContent.value.map((element) {
                              // items: controller.bannerContent.value.map((element) {
                              return GestureDetector(
                                onTap: () => controller
                                    .onClickContent(element['getLink']),
                                child: Container(
                                  clipBehavior: Clip.hardEdge,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  width: MediaQuery.of(context).size.width,
                                  child: CachedNetworkImage(
                                    imageUrl: element['imageUrl'] ?? '-',
                                    fit: BoxFit.fitWidth,
                                    errorWidget: (context, url, error) {
                                      return Container(
                                        width: 100,
                                        height: 100,
                                        color: Colors.white,
                                        child: const Text(
                                          "Image not found",
                                          style: TextStyle(
                                            color: Colors.black,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              );
                            }).toList(),
                            options: CarouselOptions(
                              // height: 120.0,
                              // height: 242.0,
                              viewportFraction: 1,
                              autoPlay: true,
                              autoPlayInterval: Duration(
                                seconds: 5,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 4),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Text(
                        AppLocale.quickMenu.getString(context),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    // const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: MenuGrid(),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    //   child: SizedBox(
                    //     height: 89,
                    //     child: ListView(
                    //       clipBehavior: Clip.none,
                    //       physics: BouncingScrollPhysics(),
                    //       shrinkWrap: true,
                    //       scrollDirection: Axis.horizontal,
                    //       children: controller.menu.map(
                    //         (menu) {
                    //           return Container(
                    //             // color: Colors.red,
                    //             margin: EdgeInsets.symmetric(horizontal: 4),
                    //             width: 60,
                    //             child: Column(
                    //               crossAxisAlignment: CrossAxisAlignment.center,
                    //               children: [
                    //                 GestureDetector(
                    //                   onTap: menu.ontab,
                    //                   child: Container(
                    //                     width: 48,
                    //                     height: 48,
                    //                     // alignment: Alignment.center,
                    //                     decoration: BoxDecoration(
                    //                       color: menu.disabled == true
                    //                           ? AppColors.menuBackgroundDisabled
                    //                           : Colors.white,
                    //                       borderRadius:
                    //                           BorderRadius.circular(8),
                    //                       boxShadow: menu.disabled == true
                    //                           ? null
                    //                           : [
                    //                               AppTheme.softShadow,
                    //                             ],
                    //                     ),
                    //                     child: Container(
                    //                       alignment: Alignment.center,
                    //                       child: menu.icon,
                    //                     ),
                    //                   ),
                    //                 ),
                    //                 const SizedBox(height: 4),
                    //                 Align(
                    //                   child: menu.name,
                    //                 ),
                    //               ],
                    //             ),
                    //           );
                    //         },
                    //       ).toList(),
                    //     ),
                    //   ),
                    // ),
                    const SizedBox(height: 4),
                    Container(
                      // padding: EdgeInsets.only(top: 20),
                      clipBehavior: Clip.none,
                      // color: Colors.blue,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Positioned(
                            top: 0,
                            // left: 0,
                            // right: 0,
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    AppColors.redTone.withOpacity(0.2),
                                    Color.fromRGBO(254, 239, 239, 1)
                                        .withOpacity(0.5),
                                    Colors.white,
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  stops: [
                                    0.20,
                                    0.50,
                                    1,
                                  ],
                                ),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(3000),
                                  topRight: Radius.circular(3000),
                                ),
                              ),
                              height: 230,
                              width: 490,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 24.0,
                              right: 24,
                              top: 12,
                            ),
                            child: Column(
                              children: [
                                ShaderMask(
                                  blendMode: BlendMode.srcIn,
                                  shaderCallback: (bounds) {
                                    return LinearGradient(
                                      colors: [
                                        AppColors.redTone,
                                        AppColors.redTone.withOpacity(0.4),
                                      ],
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                    ).createShader(
                                      Rect.fromLTWH(
                                          0, 0, bounds.width, bounds.height),
                                    );
                                  },
                                  child: Text(
                                    AppLocale.specialForYou.getString(context),
                                    style: TextStyle(
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                GestureDetector(
                                  onTap: () {
                                    Get.toNamed(RouteName.videoMenu);
                                  },
                                  child: MenuCardComponent(
                                    title: AppLocale.socialMediaFamousTeachers
                                        .getString(context),
                                    backgroundImageUrl:
                                        'https://baas.moevedigital.com/v1/storage/buckets/66fa748a001a67ac8a70/files/67628a9f0019f3d0086d/view?project=667afb24000fbd66b4df',
                                  ),
                                ),
                                // const SizedBox(height: 8),
                                // MenuCardComponent(
                                //   title: AppLocale.lotteryPredict
                                //       .getString(context),
                                //   backgroundImageUrl:
                                //       'https://baas.moevedigital.com/v1/storage/buckets/66fa748a001a67ac8a70/files/67628aaa001c11630759/view?project=667afb24000fbd66b4df',
                                // ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 8,
                right: 16,
                child: SafeArea(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 16,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 22,
                          height: 22,
                          child: SvgPicture.asset(
                            AppIcon.timer,
                            colorFilter: const ColorFilter.mode(
                              Colors.white,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Obx(() {
                          return Text(
                            CommonFn.renderCountdown(
                                controller.remainingDateTime.value),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          );
                        }),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () {
                            controller.gotoNotification();
                          },
                          child: SizedBox(
                            width: 22,
                            height: 22,
                            child: SvgPicture.asset(
                              AppIcon.notification,
                              colorFilter: const ColorFilter.mode(
                                Colors.white,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () {
                            Get.toNamed(RouteName.setting);
                          },
                          child: SizedBox(
                            width: 22,
                            height: 22,
                            child: SvgPicture.asset(
                              AppIcon.setting_2,
                              colorFilter: const ColorFilter.mode(
                                Colors.white,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
