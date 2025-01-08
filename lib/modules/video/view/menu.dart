import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/components/header.dart';
import 'package:lottery_ck/modules/home/controller/home.controller.dart';
import 'package:lottery_ck/modules/layout/controller/layout.controller.dart';
import 'package:lottery_ck/modules/video/view/video.dart';
import 'package:lottery_ck/res/app_locale.dart';
import 'package:lottery_ck/res/color.dart';
import 'package:lottery_ck/res/icon.dart';
import 'package:lottery_ck/route/route_name.dart';
import 'package:lottery_ck/utils.dart';
import 'package:lottery_ck/utils/theme.dart';

class VideoMenu extends StatelessWidget {
  const VideoMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Header(
              title: AppLocale.socialMediaFamousTeachers.getString(context),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      AppLocale.all.getString(context),
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        width: 1,
                        color: AppColors.primary,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      AppLocale.horoscopeToday.getString(context),
                      style: TextStyle(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        width: 1,
                        color: AppColors.primary,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      AppLocale.luckyNumber.getString(context),
                      style: TextStyle(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
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
                        child: Opacity(
                          opacity: 0.6,
                          child: Container(
                            clipBehavior: Clip.hardEdge,
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(52),
                                topRight: Radius.circular(52),
                              ),
                            ),
                            child: CachedNetworkImage(
                              imageUrl: backgroundTheme,
                              fit: BoxFit.fitWidth,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  Obx(() {
                    final videoList = HomeController.to.videoContent.value;
                    final onlyUrl = videoList
                        .map((video) => video['videoUrl'] as String)
                        .toList();
                    return GridView.builder(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        childAspectRatio: 8 / 16,
                        crossAxisSpacing: 4,
                        mainAxisSpacing: 4,
                      ),
                      itemBuilder: (context, index) {
                        final video = videoList[index];
                        return GestureDetector(
                          onTap: () {
                            logger.d("message");
                            logger.d(onlyUrl);
                            Get.toNamed(
                              RouteName.videoFullscreen,
                              arguments: [
                                onlyUrl,
                              ],
                            );
                          },
                          child: VideComponents(
                            url: video['videoUrl'],
                          ),
                        );
                      },
                      itemCount: videoList.length,
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
