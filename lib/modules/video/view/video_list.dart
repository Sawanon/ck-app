import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottery_ck/modules/video/view/video.dart';
import 'package:lottery_ck/res/color.dart';
import 'package:lottery_ck/res/constant.dart';
import 'package:lottery_ck/res/icon.dart';
import 'package:url_launcher/url_launcher.dart';

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
    double heightVideo = 160;
    return Container(
      height: heightVideo,
      child: ListView(
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        children: [
          // VideComponents(
          //   url:
          //       "${AppConst.apiUrl}/upload/video/811e64693eac2a91-1727773426351-ScreenRecording2567-10-01at15.06.49.mov",
          //   link:
          //       "https://www.tiktok.com/@peternakhin/video/7273785555383635205",
          // ),
          // const SizedBox(width: 16),
          VideComponents(
            url: "${AppConst.cloudfareUrl}/video1.mp4",
            link:
                "https://www.tiktok.com/@peternakhin/video/7273785555383635205",
          ),
          const SizedBox(width: 16),
          VideComponents(
            url: "${AppConst.cloudfareUrl}/video2.mp4",
            link:
                "https://www.tiktok.com/@jotahovygt8/video/7410042369090800914",
          ),
          const SizedBox(width: 16),
          VideComponents(
            url: "${AppConst.cloudfareUrl}/video3.mp4",
            link:
                "https://www.tiktok.com/@phattraporn000/video/7094624978439507226",
          ),
          const SizedBox(width: 16),
          VideComponents(
            url: "${AppConst.cloudfareUrl}/video4.mp4",
            link:
                "https://www.tiktok.com/@boybigboss2/video/7210759082750332161?is_from_webapp=1&sender_device=pc&web_id=7410385762262205970",
          ),
          const SizedBox(width: 16),
          GestureDetector(
            onTap: () async {
              await launchUrl(Uri.parse(
                "https://www.tiktok.com/@v509319/video/7424372970006596907?is_from_webapp=1&sender_device=pc&web_id=7410385762262205970",
              ));
            },
            child: Container(
              width: heightVideo * (9 / 16),
              height: heightVideo,
              decoration: BoxDecoration(
                // color: Colors.grey.shade300,
                border: Border.all(width: 1, color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 48,
                    width: 48,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primary,
                          AppColors.primaryEnd,
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: SvgPicture.asset(
                        AppIcon.arrowRight,
                        colorFilter: ColorFilter.mode(
                          Colors.white,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "More",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.black.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),
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
