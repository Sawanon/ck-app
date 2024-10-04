import 'package:flutter/material.dart';
import 'package:lottery_ck/modules/video/view/video.dart';
import 'package:lottery_ck/res/constant.dart';

class VideoToomany extends StatelessWidget {
  const VideoToomany({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: VideComponents(
          url:
              "${AppConst.apiUrl}/upload/video/811e64693eac2a91-1727773426351-ScreenRecording2567-10-01at15.06.49.mov",
          link: "https://www.tiktok.com/@peternakhin/video/7273785555383635205",
        ),
      ),
    );
  }
}
