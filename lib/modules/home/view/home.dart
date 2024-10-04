import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/components/long_button.dart';
import 'package:lottery_ck/main.dart';
import 'package:lottery_ck/modules/buy_lottery/view/buy_lottery.dart';
import 'package:lottery_ck/modules/home/controller/home.controller.dart';
import 'package:lottery_ck/modules/video/view/video_list.dart';
import 'package:lottery_ck/res/app_locale.dart';
import 'package:lottery_ck/res/color.dart';
import 'package:lottery_ck/res/constant.dart';
import 'package:lottery_ck/res/icon.dart';
import 'package:lottery_ck/res/logo.dart';
import 'package:lottery_ck/route/route_name.dart';
import 'package:lottery_ck/storage.dart';
import 'package:lottery_ck/utils.dart';
import 'package:lottery_ck/utils/theme.dart';
import 'package:video_player/video_player.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      builder: (controller) {
        return Scaffold(
          body: Stack(
            children: [
              Padding(
                // padding: const EdgeInsets.only(
                //     top: 16, left: 16, right: 16, bottom: 144),
                padding: EdgeInsets.all(16),
                child: ListView(
                  clipBehavior: Clip.none,
                  physics: BouncingScrollPhysics(),
                  shrinkWrap: true,
                  children: [
                    AspectRatio(
                        aspectRatio: 16 / 9,
                        child: CarouselSlider(
                          items: [
                            "https://baas.moevedigital.com/v1/storage/buckets/news_image/files/66d532000003e376a41c/view?project=667afb24000fbd66b4df&mode=admin",
                            "https://baas.moevedigital.com/v1/storage/buckets/news_image/files/66d54346001938c02f20/view?project=667afb24000fbd66b4df&mode=admin",
                          ].map((element) {
                            return Container(
                              width: MediaQuery.of(context).size.width,
                              child: Image.network(element),
                              // child: CachedNetworkImage(
                              //   imageUrl: element,
                              //   progressIndicatorBuilder: (context, url, progress) => Center(
                              //     child: CircularProgressIndicator(
                              //       value: progress.progress,
                              //     ),
                              //   ),
                              //   errorWidget: (context, url, error) => Icon(Icons.error),
                              // ),
                              // child: Image.network(
                              //   element,
                              //   loadingBuilder:
                              //       (context, child, loadingProgress) {
                              //     if (loadingProgress == null) {
                              //       return child;
                              //     } else {
                              //       return Center(
                              //         child: CircularProgressIndicator(
                              //           value: loadingProgress
                              //                       .expectedTotalBytes !=
                              //                   null
                              //               ? loadingProgress
                              //                       .cumulativeBytesLoaded /
                              //                   loadingProgress
                              //                       .expectedTotalBytes!
                              //               : null,
                              //         ),
                              //       );
                              //     }
                              //   },
                              //   // errorBuilder:
                              //   //     (context, error, stackTrace) =>
                              //   //         Text('image not found'),
                              // ),
                            );
                          }).toList(),
                          options: CarouselOptions(
                            height: 242.0,
                            viewportFraction: 1,
                            autoPlay: true,
                            autoPlayInterval: Duration(
                              seconds: 5,
                            ),
                          ),
                        )
                        // child: Container(
                        //   decoration: BoxDecoration(
                        //     color: Colors.red.shade100,
                        //     borderRadius: BorderRadius.circular(10),
                        //     boxShadow: [
                        //       BoxShadow(
                        //         color: AppColors.shadow.withOpacity(0.2),
                        //         offset: Offset(4, 4),
                        //         blurRadius: 30,
                        //       ),
                        //     ],
                        //   ),
                        //   alignment: Alignment.center,
                        //   child: Text('Images'),
                        //   // height: 200,
                        // ),
                        ),
                    const SizedBox(height: 16),
                    // horoscope
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // horoscope
                        Column(
                          children: [
                            Container(
                              width: 52,
                              height: 52,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  AppTheme.softShadow,
                                ],
                              ),
                              child: SizedBox(
                                height: 32,
                                width: 32,
                                child: SvgPicture.asset(AppIcon.horoscope),
                              ),
                            ),
                            Text(
                              AppLocale.horoscope.getString(context),
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        // random
                        Column(
                          children: [
                            Container(
                              alignment: Alignment.center,
                              width: 52,
                              height: 52,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  AppTheme.softShadow,
                                ],
                              ),
                              child: SizedBox(
                                height: 32,
                                width: 32,
                                child: SvgPicture.asset(
                                  AppIcon.lotteryBold,
                                  colorFilter: const ColorFilter.mode(
                                      AppColors.menuIcon, BlendMode.srcIn),
                                ),
                              ),
                            ),
                            Text(
                              AppLocale.random.getString(context),
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        // animalMenu
                        Column(
                          children: [
                            GestureDetector(
                              onTap: controller.gotoAnimal,
                              child: Container(
                                alignment: Alignment.center,
                                width: 52,
                                height: 52,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: [
                                    AppTheme.softShadow,
                                  ],
                                ),
                                child: SizedBox(
                                  height: 32,
                                  width: 32,
                                  child: SvgPicture.asset(AppIcon.animalMenu),
                                ),
                              ),
                            ),
                            Text(
                              AppLocale.animal.getString(context),
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        // lotteryResult
                        Column(
                          children: [
                            GestureDetector(
                              onTap: controller.gotoLotteryResult,
                              child: Container(
                                alignment: Alignment.center,
                                width: 52,
                                height: 52,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: [
                                    AppTheme.softShadow,
                                  ],
                                ),
                                child: SizedBox(
                                  height: 32,
                                  width: 32,
                                  child:
                                      SvgPicture.asset(AppIcon.lotteryResult),
                                ),
                              ),
                            ),
                            Text(
                              AppLocale.lotteryResult.getString(context),
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        // wallpaper
                        Column(
                          children: [
                            Container(
                              alignment: Alignment.center,
                              width: 52,
                              height: 52,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  AppTheme.softShadow,
                                ],
                              ),
                              child: SizedBox(
                                height: 32,
                                width: 32,
                                child: SvgPicture.asset(AppIcon.wallpaper),
                              ),
                            ),
                            Text(
                              AppLocale.wallpaper.getString(context),
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onDoubleTap: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return Builder(builder: (context) {
                                  GlobalKey<FormState> makey = GlobalKey();
                                  return Center(
                                    child: Material(
                                      color: Colors.transparent,
                                      child: Form(
                                        key: makey,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8, horizontal: 16),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            color: Colors.white,
                                          ),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                "Enter host name api back-end",
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                "Ex. https://5356-2405-9800-b920-d13f-5d5e-8048-dbf9-abd9.ngrok-free.app/api",
                                                style: TextStyle(
                                                  fontSize: 12,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 48,
                                                width: 200,
                                                child: TextFormField(
                                                  initialValue: AppConst.apiUrl,
                                                  decoration: InputDecoration(
                                                    contentPadding:
                                                        EdgeInsets.all(8),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      borderSide:
                                                          const BorderSide(
                                                        color:
                                                            AppColors.primary,
                                                      ),
                                                    ),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      borderSide:
                                                          const BorderSide(
                                                        color:
                                                            AppColors.primary,
                                                        width: 2,
                                                      ),
                                                    ),
                                                    errorBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      borderSide:
                                                          const BorderSide(
                                                        color: AppColors
                                                            .errorBorder,
                                                        width: 4,
                                                      ),
                                                    ),
                                                    focusedErrorBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      borderSide:
                                                          const BorderSide(
                                                        color: AppColors
                                                            .errorBorder,
                                                        width: 4,
                                                      ),
                                                    ),
                                                  ),
                                                  // onChanged: (value) {
                                                  //   logger.d("onchange");
                                                  //   if (value == "") return;
                                                  //   AppConst.apiUrl = value;
                                                  // },
                                                  onSaved: (newValue) {
                                                    if (newValue == "" ||
                                                        newValue == null) {
                                                      return;
                                                    }

                                                    AppConst.apiUrl = newValue;
                                                    Get.back();
                                                  },
                                                ),
                                              ),
                                              LongButton(
                                                onPressed: () {
                                                  makey.currentState?.save();
                                                },
                                                child: Text("Save"),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                });
                              },
                            );
                          },
                          // onTap: () {
                          // controller.getLotteryDate();
                          // AppConst.apiUrl = "namo";
                          // logger.d(AppConst.apiUrl);
                          // },
                          child: GestureDetector(
                            onTap: () async {
                              final token =
                                  await StorageController.to.getAppToken();
                              logger.d("token: $token");
                            },
                            child: SizedBox(
                              // height: 30,
                              width: (MediaQuery.of(context).size.width / 2) -
                                  (16 * 2),
                              child: Image.asset(
                                Logo.ck,
                                height: 28,
                              ),
                            ),
                          ),
                        ),
                        Text(
                          controller.lotteryDateStr != null
                              ? "${AppLocale.lotteryDateAt.getString(context)} ${controller.lotteryDateStr}"
                              : "",
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.primary,
                            AppColors.primaryEnd,
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: [
                            0.0,
                            1.0,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.shadow.withOpacity(0.2),
                            offset: const Offset(4, 4),
                            blurRadius: 30,
                          ),
                        ],
                      ),
                      child: Obx(() {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.only(bottom: 4),
                              width: 60,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    "${controller.remainingDateTime.value.inDays}",
                                    style: TextStyle(
                                      fontSize: 40,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black.withOpacity(0.8),
                                    ),
                                  ),
                                  Text(
                                    AppLocale.day.getString(context),
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black.withOpacity(0.8),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.only(bottom: 4),
                              width: 60,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    "${controller.remainingDateTime.value.inHours.remainder(24)}",
                                    style: TextStyle(
                                      fontSize: 40,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black.withOpacity(0.8),
                                    ),
                                  ),
                                  Text(
                                    AppLocale.hour.getString(context),
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black.withOpacity(0.8),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.only(bottom: 4),
                              width: 60,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    "${controller.remainingDateTime.value.inMinutes.remainder(60)}",
                                    style: TextStyle(
                                      fontSize: 40,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black.withOpacity(0.8),
                                    ),
                                  ),
                                  Text(
                                    AppLocale.minute.getString(context),
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black.withOpacity(0.8),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.only(bottom: 4),
                              width: 60,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    "${controller.remainingDateTime.value.inSeconds.remainder(60)}",
                                    style: TextStyle(
                                      fontSize: 40,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black.withOpacity(0.8),
                                    ),
                                  ),
                                  Text(
                                    AppLocale.second.getString(context),
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black.withOpacity(0.8),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      }),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(AppLocale.lotteryPredict.getString(context)),
                        GestureDetector(
                          onTap: () {
                            Get.rawSnackbar(message: "coming soon");
                          },
                          child: Text(
                            AppLocale.viewAll.getString(context),
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              color: Colors.black.withOpacity(0.8),
                              decorationColor: Colors.black.withOpacity(0.8),
                              decorationThickness: 1.2,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    VideoList(),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppLocale.horoscopeToday.getString(context),
                          style: TextStyle(
                            color: Colors.black.withOpacity(0.8),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.rawSnackbar(message: "coming soon");
                          },
                          child: Text(
                            AppLocale.viewAll.getString(context),
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              color: Colors.black.withOpacity(0.8),
                              decorationColor: Colors.black.withOpacity(0.8),
                              decorationThickness: 1.2,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Builder(builder: (context) {
                      final screenWidth = MediaQuery.of(context).size.width;
                      logger.d("screenWidth: $screenWidth");
                      return SizedBox(
                        height: screenWidth / 3,
                        child: Obx(() {
                          return ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                if (controller.artworksList.length - 1 <
                                    index) {
                                  return Container(
                                    width: screenWidth / 3,
                                    height: screenWidth / 3,
                                    decoration: BoxDecoration(
                                      // color: Colors.grey.shade300,
                                      border: Border.all(
                                          width: 1,
                                          color: Colors.grey.shade300),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          height: 48,
                                          width: 48,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            gradient: LinearGradient(
                                              colors: [
                                                AppColors.primary,
                                                AppColors.primaryEnd,
                                              ],
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                            ),
                                          ),
                                          child: SizedBox(
                                            width: 24,
                                            height: 24,
                                            child: SvgPicture.asset(
                                              AppIcon.arrowRight,
                                              colorFilter: ColorFilter.mode(
                                                Colors.white,
                                                BlendMode.srcIn,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          "More",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color:
                                                Colors.black.withOpacity(0.8),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                                return SizedBox(
                                  width: screenWidth / 3,
                                  height: screenWidth / 3,
                                  child: Image.network(
                                    controller.artworksList.value[index]["url"],
                                    width: double.infinity,
                                  ),
                                );
                              },
                              separatorBuilder: (context, index) =>
                                  const SizedBox(width: 16),
                              itemCount:
                                  controller.artworksList.value.length + 1);
                        }),
                        // child: Obx(() {
                        //   return ListView(
                        //     scrollDirection: Axis.horizontal,
                        //     physics: const BouncingScrollPhysics(),
                        //     children:
                        //         [...controller.artworksList.value, null].map(
                        //       (artwork) {
                        //         if (artwork == null) {
                        //           return Container(
                        //             width: screenWidth / 3,
                        //             height: screenWidth / 3,
                        //             decoration: BoxDecoration(
                        //               // color: Colors.grey.shade300,
                        //               border: Border.all(
                        //                   width: 1,
                        //                   color: Colors.grey.shade300),
                        //               borderRadius: BorderRadius.circular(10),
                        //             ),
                        //             child: Column(
                        //               mainAxisSize: MainAxisSize.min,
                        //               mainAxisAlignment:
                        //                   MainAxisAlignment.center,
                        //               children: [
                        //                 Container(
                        //                   height: 48,
                        //                   width: 48,
                        //                   alignment: Alignment.center,
                        //                   decoration: BoxDecoration(
                        //                     shape: BoxShape.circle,
                        //                     gradient: LinearGradient(
                        //                       colors: [
                        //                         AppColors.primary,
                        //                         AppColors.primaryEnd,
                        //                       ],
                        //                       begin: Alignment.topCenter,
                        //                       end: Alignment.bottomCenter,
                        //                     ),
                        //                   ),
                        //                   child: SizedBox(
                        //                     width: 24,
                        //                     height: 24,
                        //                     child: SvgPicture.asset(
                        //                       AppIcon.arrowRight,
                        //                       colorFilter: ColorFilter.mode(
                        //                         Colors.white,
                        //                         BlendMode.srcIn,
                        //                       ),
                        //                     ),
                        //                   ),
                        //                 ),
                        //                 const SizedBox(height: 4),
                        //                 Text(
                        //                   "More",
                        //                   style: TextStyle(
                        //                     fontWeight: FontWeight.w600,
                        //                     color:
                        //                         Colors.black.withOpacity(0.8),
                        //                   ),
                        //                 ),
                        //               ],
                        //             ),
                        //           );
                        //         }
                        //         return SizedBox(
                        //           width: screenWidth / 3,
                        //           height: screenWidth / 3,
                        //           child: Image.network(
                        //             artwork["url"],
                        //             width: double.infinity,
                        //           ),
                        //         );
                        //       },
                        //     ).toList(),
                        //     // children: [
                        //     //   SizedBox(
                        //     //     width: screenWidth / 3,
                        //     //     height: screenWidth / 3,
                        //     //     child: Image.asset(
                        //     //       "assets/image1.png",
                        //     //       width: double.infinity,
                        //     //     ),
                        //     //   ),
                        //     //   const SizedBox(width: 16),
                        //     //   SizedBox(
                        //     //     width: screenWidth / 3,
                        //     //     height: screenWidth / 3,
                        //     //     child: Image.asset(
                        //     //       "assets/image2.png",
                        //     //       width: double.infinity,
                        //     //     ),
                        //     //   ),
                        //     //   const SizedBox(width: 16),
                        //     //   SizedBox(
                        //     //     width: screenWidth / 3,
                        //     //     height: screenWidth / 3,
                        //     //     child: Image.asset(
                        //     //       "assets/image3.png",
                        //     //       width: double.infinity,
                        //     //     ),
                        //     //   ),
                        //     //   const SizedBox(width: 16),
                        //     //   SizedBox(
                        //     //     width: screenWidth / 3,
                        //     //     height: screenWidth / 3,
                        //     //     child: Image.asset(
                        //     //       "assets/image1.png",
                        //     //       width: double.infinity,
                        //     //     ),
                        //     //   ),
                        //     //   const SizedBox(width: 16),
                        //     //   Container(
                        //     //     width: screenWidth / 3,
                        //     //     height: screenWidth / 3,
                        //     //     decoration: BoxDecoration(
                        //     //       // color: Colors.grey.shade300,
                        //     //       border: Border.all(
                        //     //           width: 1, color: Colors.grey.shade300),
                        //     //       borderRadius: BorderRadius.circular(10),
                        //     //     ),
                        //     //     child: Column(
                        //     //       mainAxisSize: MainAxisSize.min,
                        //     //       mainAxisAlignment: MainAxisAlignment.center,
                        //     //       children: [
                        //     //         Container(
                        //     //           height: 48,
                        //     //           width: 48,
                        //     //           alignment: Alignment.center,
                        //     //           decoration: BoxDecoration(
                        //     //             shape: BoxShape.circle,
                        //     //             gradient: LinearGradient(
                        //     //               colors: [
                        //     //                 AppColors.primary,
                        //     //                 AppColors.primaryEnd,
                        //     //               ],
                        //     //               begin: Alignment.topCenter,
                        //     //               end: Alignment.bottomCenter,
                        //     //             ),
                        //     //           ),
                        //     //           child: SizedBox(
                        //     //             width: 24,
                        //     //             height: 24,
                        //     //             child: SvgPicture.asset(
                        //     //               AppIcon.arrowRight,
                        //     //               colorFilter: ColorFilter.mode(
                        //     //                 Colors.white,
                        //     //                 BlendMode.srcIn,
                        //     //               ),
                        //     //             ),
                        //     //           ),
                        //     //         ),
                        //     //         const SizedBox(height: 4),
                        //     //         Text(
                        //     //           "More",
                        //     //           style: TextStyle(
                        //     //             fontWeight: FontWeight.w600,
                        //     //             color: Colors.black.withOpacity(0.8),
                        //     //           ),
                        //     //         ),
                        //     //       ],
                        //     //     ),
                        //     //   ),
                        //     // ],
                        //   );
                        // }),
                      );
                    })
                    // Row(
                    //   children: [
                    //     Container(
                    //       clipBehavior: Clip.hardEdge,
                    //       decoration: BoxDecoration(
                    //         color: Colors.amber,
                    //         borderRadius: BorderRadius.circular(10),
                    //       ),
                    //       width: ((MediaQuery.of(context).size.width / 3) * 2) -
                    //           16 -
                    //           8,
                    //       height:
                    //           ((MediaQuery.of(context).size.width / 3) * 2) -
                    //               16 -
                    //               8,
                    //       // child: Text('${((MediaQuery.of(context).size.width / 3) * 2) - 16 - 8}'),
                    //       child: Image.asset(
                    //         "assets/image1.png",
                    //         width: double.infinity,
                    //       ),
                    //     ),
                    //     const SizedBox(width: 8),
                    //     Column(
                    //       children: [
                    //         Container(
                    //           clipBehavior: Clip.hardEdge,
                    //           decoration: BoxDecoration(
                    //             color: Colors.purple,
                    //             borderRadius: BorderRadius.circular(10),
                    //           ),
                    //           width: MediaQuery.of(context).size.width / 3 - 16,
                    //           height:
                    //               MediaQuery.of(context).size.width / 3 - 16,
                    //           // child: Text(
                    //           //     '${MediaQuery.of(context).size.width / 3 - 16}'),
                    //           child: Image.asset(
                    //             "assets/image2.png",
                    //             width: double.infinity,
                    //           ),
                    //         ),
                    //         const SizedBox(height: 8),
                    //         Container(
                    //           clipBehavior: Clip.hardEdge,
                    //           decoration: BoxDecoration(
                    //             color: Colors.blue,
                    //             borderRadius: BorderRadius.circular(10),
                    //           ),
                    //           width: MediaQuery.of(context).size.width / 3 - 16,
                    //           height:
                    //               MediaQuery.of(context).size.width / 3 - 16,
                    //           // child: Text(
                    //           //     '${MediaQuery.of(context).size.width / 3 - 16}'),
                    //           child: Image.asset(
                    //             "assets/image3.png",
                    //             width: double.infinity,
                    //           ),
                    //         ),
                    //       ],
                    //     ),
                    //   ],
                    // ),
                  ],
                ),
              ),
              // Align(
              //   alignment: controller.lotteryAlinment,
              //   child: BuyLottery(),
              // ),
            ],
          ),
        );
      },
    );
  }
}
