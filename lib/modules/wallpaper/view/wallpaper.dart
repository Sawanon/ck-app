import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/components/header.dart';
import 'package:lottery_ck/modules/home/controller/home.controller.dart';
import 'package:lottery_ck/modules/wallpaper/view/wallpaper_fullscreen.dart';
import 'package:lottery_ck/res/app_locale.dart';
import 'package:lottery_ck/res/color.dart';
import 'package:lottery_ck/res/icon.dart';
import 'package:lottery_ck/utils.dart';

class WallpaperPage extends StatelessWidget {
  const WallpaperPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      builder: (controller) {
        return Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                Header(
                  title: AppLocale.auspiciousWallpaper.getString(context),
                ),
                Expanded(
                  child: Builder(builder: (context) {
                    // if (controller.wallpaperContent.isEmpty) {
                    if (controller.wallpaperContent.isEmpty) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height / 3.5,
                            ),
                            SizedBox(
                              width: 120,
                              height: 120,
                              child: SvgPicture.asset(
                                AppIcon.image,
                                colorFilter: const ColorFilter.mode(
                                  AppColors.disableText,
                                  BlendMode.srcIn,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              AppLocale.noWallpaperTitle.getString(context),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Colors.black.withOpacity(0.4),
                              ),
                            )
                          ],
                        ),
                      );
                    }
                    return GridView.builder(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.all(8),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 8 / 16,
                        crossAxisSpacing: 4,
                        mainAxisSpacing: 4,
                      ),
                      // itemCount: 1,
                      itemCount: controller.wallpaperContent
                          .length, // Replace with your actual item count
                      itemBuilder: (context, index) {
                        final wallpaper = controller.wallpaperContent[index];
                        // final Map wallpaper = {
                        //   'name': 'name',
                        //   'wallpapers': {
                        //     'url':
                        //         'https://baas.moevedigital.com/v1/storage/buckets/66fa316200036c5ef9ee/files/679b80d400113452434c/view?project=667afb24000fbd66b4df',
                        //     'fileId': '679b80d400113452434c',
                        //     'bucketId': '66fa316200036c5ef9ee',
                        //   },
                        //   'description': 'description',
                        // };
                        return Column(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  Get.dialog(
                                    WallpaperFullscreenPage(
                                      url: wallpaper['wallpapers']['url'],
                                      name: wallpaper['wallpapers']['name'],
                                      fileId: wallpaper['wallpapers']['fileId'],
                                      bucketId: wallpaper['wallpapers']
                                          ['bucketId'],
                                      detail: wallpaper['wallpapers']['detail'],
                                    ),
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(),
                                  child: Column(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          clipBehavior: Clip.hardEdge,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          // child: Image.network(
                                          //     "${wallpaper['wallpapers']['url']}"),
                                          child: CachedNetworkImage(
                                            imageUrl:
                                                "${wallpaper['wallpapers']['url']}",
                                            progressIndicatorBuilder: (
                                              context,
                                              url,
                                              downloadProgress,
                                            ) =>
                                                Center(
                                              child: CircularProgressIndicator(
                                                value:
                                                    downloadProgress.progress,
                                              ),
                                            ),
                                            errorWidget:
                                                (context, url, error) =>
                                                    Icon(Icons.error),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        "${wallpaper['wallpapers']['name']}",
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  }),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
