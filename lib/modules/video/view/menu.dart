import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/components/header.dart';
import 'package:lottery_ck/modules/layout/controller/layout.controller.dart';
import 'package:lottery_ck/modules/video/controller/video.controller.dart';
import 'package:lottery_ck/modules/video/view/short_player.dart';
import 'package:lottery_ck/modules/video/view/video_player.dart';
import 'package:lottery_ck/res/app_locale.dart';
import 'package:lottery_ck/res/color.dart';
import 'package:lottery_ck/utils.dart';
import 'package:google_fonts/google_fonts.dart';

class VideoMenu extends StatelessWidget {
  const VideoMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<VideoController>(
      initState: (state) {
        VideoController.to.setupInPage();
      },
      builder: (controller) {
        return Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                Header(
                  title: AppLocale.socialMediaFamousTeachers.getString(context),
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 16,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 16,
                  ),
                  height: 54,
                  child: Obx(() {
                    return Row(
                      children: [
                        if (controller.categories.length > 1)
                          GestureDetector(
                            onTap: () {
                              controller.onClickCategory(0);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: 16,
                              ),
                              decoration: BoxDecoration(
                                color: controller.selectedCategory.value == 0
                                    ? AppColors.primary
                                    : Colors.white,
                                border: Border.all(
                                  width: 1,
                                  color: controller.selectedCategory.value == 0
                                      ? Colors.white
                                      : AppColors.primary,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                AppLocale.all.getString(context),
                                style: TextStyle(
                                  color: controller.selectedCategory.value == 0
                                      ? Colors.white
                                      : AppColors.primary,
                                ),
                              ),
                            ),
                          ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Obx(() {
                            return ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  final category = controller.categories[index];
                                  return GestureDetector(
                                    onTap: () {
                                      controller.onClickCategory(
                                          category.classificationId);
                                      // logger.w(category.classificationId);
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 8,
                                        horizontal: 16,
                                      ),
                                      decoration: BoxDecoration(
                                        color:
                                            controller.selectedCategory.value ==
                                                    category.classificationId
                                                ? AppColors.primary
                                                : Colors.white,
                                        border: Border.all(
                                          width: 1,
                                          color: controller
                                                      .selectedCategory.value ==
                                                  category.classificationId
                                              ? Colors.white
                                              : AppColors.primary,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        category.classification,
                                        style: TextStyle(
                                          color: controller
                                                      .selectedCategory.value ==
                                                  category.classificationId
                                              ? Colors.white
                                              : AppColors.primary,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                separatorBuilder: (context, index) {
                                  return const SizedBox(width: 4);
                                },
                                itemCount: controller.categories.length);
                          }),
                        ),
                      ],
                    );
                  }),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Builder(
                        builder: (context) {
                          final backgroundTheme =
                              LayoutController.to.randomBackgroundThemeUrl();
                          if (backgroundTheme == null) {
                            return const SizedBox.shrink();
                          }
                          return Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              clipBehavior: Clip.hardEdge,
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(24),
                                  topRight: Radius.circular(24),
                                ),
                              ),
                              child: CachedNetworkImage(
                                imageUrl: backgroundTheme,
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                          );
                        },
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.white.withOpacity(0.6),
                              Colors.white.withOpacity(0.4),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            stops: const [
                              0.7,
                              1,
                            ],
                          ),
                        ),
                      ),
                      Obx(() {
                        return GridView.builder(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            childAspectRatio: 8 / 16,
                            crossAxisSpacing: 4,
                            mainAxisSpacing: 4,
                          ),
                          itemBuilder: (context, index) {
                            final video = controller.videoList[index];
                            // return Skeletonizer(
                            //   enabled: true,
                            //   child: Container(
                            //     color: Colors.grey,
                            //     width: 150,
                            //     height: 160,
                            //   ),
                            // );
                            return GestureDetector(
                              onTap: () {
                                logger.d("message");
                                Get.to(
                                  () => VideoPlayer(
                                    index: index,
                                  ),
                                );
                              },
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Expanded(
                                    child: Container(
                                      width: double.infinity,
                                      clipBehavior: Clip.hardEdge,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: ShortPlayer(
                                        videoId: video.basicInfo.vid,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    video.basicInfo.title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 12,
                                    ),
                                  )
                                ],
                              ),
                            );
                          },
                          itemCount: controller.videoList.length,
                        );
                      }),
                      // Obx(() {
                      //   final videoList = HomeController.to.videoContent.value;
                      //   final onlyUrl = videoList
                      //       .map((video) => video['videoUrl'] as String)
                      //       .toList();
                      //   return GridView.builder(
                      //     physics: const BouncingScrollPhysics(),
                      //     padding: const EdgeInsets.symmetric(horizontal: 16),
                      //     gridDelegate:
                      //         const SliverGridDelegateWithFixedCrossAxisCount(
                      //       crossAxisCount: 4,
                      //       childAspectRatio: 8 / 16,
                      //       crossAxisSpacing: 4,
                      //       mainAxisSpacing: 4,
                      //     ),
                      //     itemBuilder: (context, index) {
                      //       final video = videoList[index];
                      //       return GestureDetector(
                      //         onTap: () {
                      //           logger.d("message");
                      //           logger.d(onlyUrl);
                      //           Get.toNamed(
                      //             RouteName.videoFullscreen,
                      //             arguments: [
                      //               onlyUrl,
                      //             ],
                      //           );
                      //         },
                      //         child: VideComponents(
                      //           url: video['videoUrl'],
                      //         ),
                      //       );
                      //     },
                      //     itemCount: videoList.length,
                      //   );
                      // }),
                    ],
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
