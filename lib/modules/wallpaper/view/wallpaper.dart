import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/components/header.dart';
import 'package:lottery_ck/modules/home/controller/home.controller.dart';
import 'package:lottery_ck/modules/wallpaper/view/wallpaper_fullscreen.dart';
import 'package:lottery_ck/res/color.dart';

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
                  title: "Wallpaper",
                ),
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemBuilder: (context, index) {
                      final wallpaper = controller.wallpaperContent[index];
                      return GestureDetector(
                        onTap: () {
                          Get.dialog(
                            WallpaperFullscreenPage(
                              url: wallpaper['wallpapers']['url'],
                              fileId: wallpaper['wallpapers']['fileId'],
                              bucketId: wallpaper['wallpapers']['bucketId'],
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(),
                          child: Column(
                            children: [
                              Image.network(
                                  "${wallpaper['wallpapers']['url']}"),
                              const SizedBox(height: 8),
                              Text(
                                "${wallpaper['name']}",
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return SizedBox(height: 8);
                    },
                    itemCount: controller.wallpaperContent.length,
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
