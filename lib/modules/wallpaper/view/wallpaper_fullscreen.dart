import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/components/header.dart';
import 'package:lottery_ck/components/long_button.dart';
import 'package:lottery_ck/modules/home/controller/home.controller.dart';
import 'package:lottery_ck/res/app_locale.dart';
import 'package:lottery_ck/res/color.dart';
import 'package:lottery_ck/res/icon.dart';

class WallpaperFullscreenPage extends StatefulWidget {
  final String url;
  final String fileId;
  final String bucketId;
  final String name;

  const WallpaperFullscreenPage({
    super.key,
    required this.url,
    required this.fileId,
    required this.bucketId,
    this.name = "",
  });

  @override
  State<WallpaperFullscreenPage> createState() =>
      _WallpaperFullscreenPageState();
}

class _WallpaperFullscreenPageState extends State<WallpaperFullscreenPage> {
  bool isLoading = false;

  void setIsLoading(bool value) {
    setState(() {
      isLoading = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      builder: (controller) {
        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Header(
                    title: widget.name,
                  ),
                  Center(
                    // child: Image.network(url),
                    child: CachedNetworkImage(
                      imageUrl: widget.url,
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
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  ),
                  const SizedBox(height: 16),
                  LongButton(
                    isLoading: isLoading,
                    disabled: isLoading,
                    onPressed: () async {
                      setIsLoading(true);
                      await controller.downloadWallpaper(
                          widget.fileId, widget.bucketId);
                      setIsLoading(false);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 24,
                          height: 24,
                          child: SvgPicture.asset(
                            AppIcon.download,
                            colorFilter: const ColorFilter.mode(
                              Colors.white,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          AppLocale.save.getString(context),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // GestureDetector(
                  //   onTap: () {
                  //     controller.downloadWallpaper(
                  //         widget.fileId, widget.bucketId);
                  //   },
                  //   child: Container(
                  //     padding: const EdgeInsets.all(8),
                  //     decoration: BoxDecoration(
                  //       color: AppColors.primary,
                  //       borderRadius: BorderRadius.circular(8),
                  //     ),
                  //     child: Row(
                  //       mainAxisAlignment: MainAxisAlignment.center,
                  //       children: [
                  //         SizedBox(
                  //           width: 24,
                  //           height: 24,
                  //           child: SvgPicture.asset(
                  //             AppIcon.download,
                  //             colorFilter: const ColorFilter.mode(
                  //               Colors.white,
                  //               BlendMode.srcIn,
                  //             ),
                  //           ),
                  //         ),
                  //         const SizedBox(width: 8),
                  //         Text(
                  //           AppLocale.save.getString(context),
                  //           style: TextStyle(
                  //             fontSize: 16,
                  //             fontWeight: FontWeight.bold,
                  //             color: Colors.white,
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
