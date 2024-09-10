import 'package:flutter/material.dart';
import 'package:lottery_ck/res/color.dart';
import 'package:lottery_ck/res/constant.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

class VideComponents extends StatefulWidget {
  final String videoName;
  final String link;
  const VideComponents({
    super.key,
    required this.videoName,
    required this.link,
  });

  @override
  State<VideComponents> createState() => _VideComponentsState();
}

class _VideComponentsState extends State<VideComponents> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    _controller = VideoPlayerController.networkUrl(
        Uri.parse("${AppConst.cloudfareUrl}/${widget.videoName}"),
        videoPlayerOptions: VideoPlayerOptions(
          mixWithOthers: true,
        ));
    _controller.setVolume(0.0);
    _controller.initialize().then(
      (_) {
        _controller.setLooping(true);
        _controller.play();
        setState(() {});
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double heightVideo = 180;
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
