import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/components/header.dart';
import 'package:lottery_ck/components/long_button.dart';
import 'package:lottery_ck/modules/home/controller/home.controller.dart';
import 'package:lottery_ck/res/app_locale.dart';
import 'package:lottery_ck/res/color.dart';
import 'package:lottery_ck/res/icon.dart';
import 'package:lottery_ck/utils/theme.dart';
import 'package:google_fonts/google_fonts.dart';

class WallpaperFullscreenPage extends StatefulWidget {
  final String url;
  final String fileId;
  final String bucketId;
  final String name;
  final String detail;

  const WallpaperFullscreenPage({
    super.key,
    required this.url,
    required this.fileId,
    required this.bucketId,
    this.name = "",
    required this.detail,
  });

  @override
  State<WallpaperFullscreenPage> createState() =>
      _WallpaperFullscreenPageState();
}

class _WallpaperFullscreenPageState extends State<WallpaperFullscreenPage> {
  bool isLoading = false;

  bool isOpen = false;
  bool isChangeToDes = false;

  void setIsLoading(bool value) {
    setState(() {
      isLoading = value;
    });
  }

  void flipWallpaper() async {
    setState(() {
      isOpen = true;
    });
    await Future.delayed(const Duration(milliseconds: 250), () {
      setState(() {
        isChangeToDes = true;
      });
    });
  }

  void closeDesc() async {
    setState(() {
      isOpen = false;
    });
    await Future.delayed(const Duration(milliseconds: 250), () {
      setState(() {
        isChangeToDes = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      builder: (controller) {
        return Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                Header(
                  title: widget.name,
                ),
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            if (isOpen) {
                              closeDesc();
                              return;
                            }
                            flipWallpaper();
                          },
                          child: Container(
                            clipBehavior: Clip.hardEdge,
                            width: double.infinity,
                            margin: EdgeInsets.symmetric(
                              horizontal: 16,
                            ),
                            padding: EdgeInsets.all(isChangeToDes ? 16 : 0),
                            decoration: BoxDecoration(
                              color: isChangeToDes
                                  ? Colors.white
                                  : Colors.transparent,
                              boxShadow: [AppTheme.softShadow],
                              borderRadius:
                                  BorderRadius.circular(isChangeToDes ? 20 : 0),
                            ),
                            child: isChangeToDes
                                ? ListView(
                                    children: [
                                      Transform.flip(
                                        flipX: true,
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                            vertical: 16,
                                          ),
                                          child: Text(
                                            widget.detail,
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : Padding(
                                    padding: EdgeInsets.only(top: 20),
                                    child: CachedNetworkImage(
                                      imageUrl: widget.url,
                                      fit: BoxFit.fitHeight,
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
                                    )
                                        .animate(
                                          onPlay: (controller) => controller
                                              .repeat(), // 👈 repeat forever
                                        )
                                        .moveY(
                                          begin: 10,
                                          end: -10,
                                          curve: Curves.easeInOut,
                                          duration: const Duration(seconds: 1),
                                        )
                                        .then()
                                        .moveY(
                                          begin: -10,
                                          end: 10,
                                          duration: const Duration(seconds: 1),
                                          // curve: Curves.easeInOut,
                                        ),
                                  ),
                            // .shakeY(
                            //   amount: 2,
                            //   duration: const Duration(seconds: 2),
                            //   // curve: Curves.bounceInOut,
                            //   hz: 0.5,
                            // ),
                          )
                              .animate(
                                target: isOpen ? 1 : 0,
                              )
                              .flipH(
                                curve: Curves.easeInOut,
                                begin: 0,
                                end: 1,
                                duration: const Duration(milliseconds: 500),
                              ),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.touch_app_rounded,
                            color: Colors.grey.shade600,
                          ),
                          Text(
                            isChangeToDes
                                ? AppLocale.tapToSeeWallpaper.getString(context)
                                : AppLocale.tapToSeeTheMeaning
                                    .getString(context),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // const SizedBox(height: 16),
                Padding(
                  padding: EdgeInsets.all(16),
                  child: LongButton(
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
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
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
