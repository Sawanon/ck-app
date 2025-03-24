import 'dart:ui';

import 'package:byteplus_vod/ve_vod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/components/header.dart';
import 'package:lottery_ck/modules/appwrite/controller/appwrite.controller.dart';
import 'package:lottery_ck/modules/video/controller/video.controller.dart';
import 'package:lottery_ck/utils.dart';
import 'package:lottery_ck/utils/common_fn.dart';

class VideoPlayer extends StatefulWidget {
  final int index;
  const VideoPlayer({
    super.key,
    required this.index,
  });

  @override
  State<VideoPlayer> createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  TTVideoPlayerView? playerView;
  VodPlayerFlutter player = VodPlayerFlutter();
  PageController pageController = PageController();
  bool isPlay = false;
  String title = "Loading...";
  bool isLoading = true;

  Future<void> play() async {
    await player.play();
    setState(() {
      isPlay = true;
    });
  }

  Future<void> pause() async {
    await player.pause();
    setState(() {
      isPlay = false;
    });
  }

  Future<void> setup() async {
    await player.createPlayer();
    setState(() {
      playerView = TTVideoPlayerView(
        onPlatformViewCreated: (viewId) {
          player.setPlayerContainerView(viewId);
        },
      );
    });
    final videoList = VideoController.to.videoList;
    setSource(videoList[widget.index].basicInfo.vid);
    setTitle(videoList[widget.index].basicInfo.title);
    // pageController.jumpToPage(widget.index);
    // pageController.addListener(() {
    //   final index = pageController.page;
    //   if (index == null) {
    //     return;
    //   }
    //   // logger.w("index: ${CommonFn.isInteger(index)}");
    //   if (CommonFn.isInteger(index) == false) {
    //     pause();
    //   } else {
    //     final videoId =
    //         VideoController.to.videoList[index.toInt()].basicInfo.vid;
    //     setTitle(videoList[index.toInt()].basicInfo.title);
    //     setLoading(true);
    //     setSource(videoId);
    //   }
    //   // if (index != null) {
    //   //   final videoId = videoList[index].basicInfo.vid;
    //   //   setSource(videoId);
    //   // }
    // });
  }

  void setLoading(bool value) {
    setState(() {
      isLoading = value;
    });
  }

  void setSource(String videoId) async {
    final response = await AppWriteController.to.getVideoInfo(videoId, "auto");
    if (response.data?.result.playInfoList.isEmpty ?? true) {
      logger.e("playInfoList is empty");
      Get.rawSnackbar(message: "playInfoList is empty");
      return;
    }
    final playInfo = response.data?.result.playInfoList.first;
    final playUrl = playInfo?.mainPlayUrl ?? playInfo?.backupPlayUrl;
    TTVideoEngineUrlSource source = TTVideoEngineUrlSource.initWithURL(
      playUrl,
      videoId,
    );
    // await player.setUrlSource(source);
    await player.setMediaSource(source);
    await play();
    player.onPrepared = () {
      logger.d("onPrepared");
      setLoading(false);
    };
  }

  void setTitle(String value) {
    setState(() {
      title = value;
    });
  }

  @override
  void dispose() {
    player.stop();
    player.closeAsync();
    super.dispose();
  }

  @override
  void initState() {
    setup();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<VideoController>(builder: (controller) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Column(
            children: [
              Header(
                title: title,
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 16,
                ),
              ),
              Expanded(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Builder(
                      builder: (context) {
                        final videoData = controller.videoList[widget.index];
                        if (isLoading) {
                          return CachedNetworkImage(
                            imageUrl:
                                "http://demovodimg.mylaos.life/${videoData.basicInfo.posterUri}~tplv-vod-noop.image",
                          );
                        }
                        if (playerView == null) {
                          return const SizedBox();
                        }
                        return playerView!;
                      },
                    ),
                    if (isLoading)
                      ClipRect(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(
                            sigmaX: 10,
                            sigmaY: 10,
                          ),
                          child: Container(
                            width: 200,
                            height: 200,
                            color: Colors.black.withOpacity(0.2),
                          ),
                        ),
                      )
                    else
                      GestureDetector(
                        onTap: () {
                          if (isPlay) {
                            pause();
                          } else {
                            play();
                          }
                        },
                        child: Container(
                          color: Colors.transparent,
                          child: isPlay
                              ? SizedBox()
                              : Icon(
                                  isPlay
                                      ? Icons.pause
                                      : Icons.play_arrow_rounded,
                                  size: 56,
                                  color: Colors.white.withOpacity(0.4),
                                ),
                        ),
                      ),
                  ],
                ),
                // return Container(
                //   color: index % 2 == 0 ? Colors.black : Colors.white,
                //   child: Center(
                //     child: Text(
                //       "Video Player ${controller.videoList.length}",
                //       style: TextStyle(
                //         color: Colors.white,
                //         fontSize: 24,
                //       ),
                //     ),
                //   ),
                // );
              ),
            ],
          ),
        ),
      );
    });
  }
}
