import 'package:flutter/material.dart';
import 'package:lottery_ck/res/color.dart';
import 'package:lottery_ck/res/constant.dart';
import 'package:lottery_ck/utils.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

class VideComponents extends StatefulWidget {
  final String url;
  final String link;
  const VideComponents({
    super.key,
    required this.url,
    required this.link,
  });

  @override
  State<VideComponents> createState() => _VideComponentsState();
}

class _VideComponentsState extends State<VideComponents> {
  late VideoPlayerController _controller;

  void setupVideoPlayer() async {
    try {
      _controller = VideoPlayerController.networkUrl(
        Uri.parse(widget.url),
        videoPlayerOptions: VideoPlayerOptions(
          mixWithOthers: true,
        ),
      );
      _controller.setVolume(0.0);
      await _controller.initialize();
      _controller.setLooping(true);
      _controller.play();
      setState(() {});
    } on Exception catch (e) {
      logger.e("error: $e");
      _controller.dispose();
    }
  }

  @override
  void initState() {
    setupVideoPlayer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double heightVideo = 160;
    if (_controller.value.isInitialized) {
      return GestureDetector(
        onTap: () async {
          await launchUrl(Uri.parse(
            widget.link,
          ));
        },
        child: Container(
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
          ),
          width: heightVideo * _controller.value.aspectRatio,
          height: heightVideo,
          child: VideoPlayer(_controller),
        ),
      );
    }
    return Skeletonizer(
      enabled: true,
      child: Material(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(8),
        clipBehavior: Clip.hardEdge,
        child: Container(
          color: Colors.red,
          // decoration: BoxDecoration(
          //   borderRadius: BorderRadius.circular(8),
          // ),
          width: heightVideo * (9 / 16),
          height: heightVideo,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
