import 'package:flutter/material.dart';
import 'package:lottery_ck/modules/video/view/video.dart';
import 'package:lottery_ck/res/constant.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

/// Stateful widget to fetch and then display video content.
class VideoList extends StatefulWidget {
  const VideoList({super.key});

  @override
  _VideoListState createState() => _VideoListState();
}

class _VideoListState extends State<VideoList> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double heightVideo = 180;
    return Container(
      height: heightVideo,
      child: ListView(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        children: [
          VideComponents(
            videoName: "video1.mp4",
            link:
                "https://www.tiktok.com/@peternakhin/video/7273785555383635205",
          ),
          const SizedBox(width: 16),
          VideComponents(
            videoName: "video2.mp4",
            link:
                "https://www.tiktok.com/@jotahovygt8/video/7410042369090800914",
          ),
          const SizedBox(width: 16),
          VideComponents(
            videoName: "video3.mp4",
            link:
                "https://www.tiktok.com/@phattraporn000/video/7094624978439507226",
          ),
          const SizedBox(width: 16),
          VideComponents(
            videoName: "video4.mp4",
            link:
                "https://www.tiktok.com/@boybigboss2/video/7210759082750332161?is_from_webapp=1&sender_device=pc&web_id=7410385762262205970",
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
