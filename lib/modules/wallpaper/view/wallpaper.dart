import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/components/header.dart';
import 'package:lottery_ck/modules/home/controller/home.controller.dart';
import 'package:lottery_ck/modules/wallpaper/view/wallpaper_fullscreen.dart';
import 'package:lottery_ck/res/app_locale.dart';
import 'package:lottery_ck/res/color.dart';
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
                  title: AppLocale.wallpaper.getString(context),
                ),
                Expanded(
                  child: GridView.builder(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.all(8),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 8 / 16,
                      crossAxisSpacing: 4,
                      mainAxisSpacing: 4,
                    ),
                    itemCount: controller.wallpaperContent
                        .length, // Replace with your actual item count
                    itemBuilder: (context, index) {
                      final wallpaper = controller.wallpaperContent[index];
                      return Column(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Get.dialog(
                                  WallpaperFullscreenPage(
                                    url: wallpaper['wallpapers']['url'],
                                    name: wallpaper['name'],
                                    fileId: wallpaper['wallpapers']['fileId'],
                                    bucketId: wallpaper['wallpapers']
                                        ['bucketId'],
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
                                                BorderRadius.circular(8)),
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
                                              value: downloadProgress.progress,
                                            ),
                                          ),
                                          errorWidget: (context, url, error) =>
                                              Icon(Icons.error),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      "${wallpaper['name']}",
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
