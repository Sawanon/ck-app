import 'package:byteplus_vod/ve_vod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/modules/appwrite/controller/appwrite.controller.dart';
import 'package:lottery_ck/res/color.dart';
import 'package:lottery_ck/utils.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ShortPlayer extends StatefulWidget {
  final String videoId;
  const ShortPlayer({
    super.key,
    required this.videoId,
  });

  @override
  State<ShortPlayer> createState() => _ShortPlayerState();
}

class _ShortPlayerState extends State<ShortPlayer> {
  TTVideoPlayerView? playerView;
  VodPlayerFlutter player = VodPlayerFlutter();
  String? coverUrl;

  Future<void> setup() async {
    await player.createPlayer();
    setState(() {
      playerView = TTVideoPlayerView(
        onPlatformViewCreated: (viewId) {
          logger.d(viewId);
          player.setPlayerContainerView(viewId);
        },
      );
    });
    final response = await AppWriteController.to.getSnapshot(widget.videoId);
    if (response.data?.result.animatedPosterSnapshots.isEmpty ?? true) {
      logger.e("animatedPosterSnapshots is empty");
      Get.rawSnackbar(
        message: "No snapshot found",
      );
      return;
    }
    final snapshot = response.data?.result.animatedPosterSnapshots.first;
    setState(() {
      coverUrl = snapshot?.url;
    });
    // // api call to get video info
    // final response = await AppWriteController.to.getVideoInfo(
    //   widget.videoId,
    //   "240p",
    // );
    // if (response.data?.result.playInfoList.isEmpty ?? true) {
    //   logger.e("playInfoList is empty");
    //   return;
    // }
    // final playInfo = response.data?.result.playInfoList.first;
    // final playUrl = playInfo?.mainPlayUrl ?? playInfo?.backupPlayUrl;
    // final posterUrl = response.data?.result.posterUrl;
    // setState(() {
    //   coverUrl = posterUrl;
    // });
    // logger.w("posterUrl: $posterUrl");
    // logger.w("playUrl: $playUrl");
    // TTVideoEngineUrlSource source = TTVideoEngineUrlSource.initWithURL(
    //   // 'https://demovod.mylaos.life/83b83759f2264edeaf0e62cffd250028/master.m3u8?auth_key=1739336478-d333ebeafbe04905a5332d048b570d2c-0-0477f86a0edc0377115555711babdf58',
    //   playUrl,
    //   widget.videoId,
    // );
    // // await player.configResolutionBeforeStart()
    // // player.onPrepared = () async {
    // //   TTVideoEngineResolutionType resolution = await player.currentResolution;
    // //   logger.w(resolution.toString());
    // //   logger.w("onPrepared");

    // //   player.fetchedVideoModel = () async {
    // //     List<TTVideoEngineResolutionType>? resTypes =
    // //         await player.supportedResolutionTypes;
    // //     logger.w(resTypes);
    // //     logger.w("fetchedVideoModel");
    // //   };
    // // };

    // await player.setStartTimeMs(2000);
    // await player.seekToTimeMs(
    //   time: 3000,
    //   seekCompleted: (p0) {
    //     logger.w("seek naCompleted");
    //   },
    //   seekRenderCompleted: () {
    //     logger.w("seek naRenderCompleted");
    //   },
    // );
    // await player.setMediaSource(source);
    // await player.play();
    // Future.delayed(const Duration(seconds: 4), () async {
    //   await player.stop();
    // });
    // end of api call to get video info
  }

  @override
  void dispose() {
    // player.stop();
    // player.closeAsync();
    super.dispose();
  }

  @override
  void initState() {
    setup();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // if (playerView == null) {
    if (coverUrl == null) {
      return Skeletonizer(
        enabled: true,
        child: Container(
          color: Colors.grey,
          width: double.infinity,
          height: double.infinity,
        ),
      );
    }
    // return playerView!;
    return CachedNetworkImage(
      imageUrl: coverUrl!,
      fit: BoxFit.cover,
    );

    // return const Center(
    //   child: CircularProgressIndicator(
    //     color: Colors.black,
    //   ),
    // );
  }
}
