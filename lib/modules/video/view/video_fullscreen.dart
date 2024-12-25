import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class VideoFullscreen extends StatefulWidget {
  // final List<String> urlList;
  const VideoFullscreen({
    super.key,
    // required this.urlList,
  });

  @override
  State<VideoFullscreen> createState() => _VideoFullscreenState();
}

class _VideoFullscreenState extends State<VideoFullscreen> {
  final List<String> urlList = Get.arguments[0];
  List<VideoPlayerController> controllers = [];

  Future<void> setup() async {
    // สร้าง VideoPlayerController สำหรับแต่ละวิดีโอ
    for (var url in urlList) {
      final controller = VideoPlayerController.networkUrl(
        Uri.parse(url),
      );
      controller.setVolume(0.0);
      controller.initialize();
      controllers.add(controller);
    }
  }

  @override
  void initState() {
    super.initState();
    setup();
  }

  @override
  void dispose() {
    // ลบ VideoPlayerController เพื่อคืนหน่วยความจำ
    for (var controller in controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: PageView.builder(
          scrollDirection: Axis.vertical,
          onPageChanged: (value) {
            final controller = controllers[value];
            controller.play();
          },
          itemBuilder: (context, index) {
            final controller = controllers[index];

            if (index == 0) {
              controller.play();
            }
            return Stack(
              alignment: Alignment.center,
              children: [
                // if (controller.value.isInitialized)
                GestureDetector(
                  onTap: () {
                    setState(() {
                      if (controller.value.isPlaying) {
                        controller.pause();
                      } else {
                        controller.play();
                      }
                    });
                  },
                  child: AspectRatio(
                    aspectRatio: 9 / 16,
                    child: VideoPlayer(controller),
                  ),
                )
                // else
                //   Center(child: CircularProgressIndicator()),
                // Positioned(
                //   bottom: 50,
                //   left: 20,
                //   child: Text(
                //     'Video ${index + 1}',
                //     style: TextStyle(
                //       color: Colors.white,
                //       fontSize: 20,
                //       fontWeight: FontWeight.bold,
                //     ),
                //   ),
                // ),
              ],
            );
          },
          itemCount: urlList.length,
        ),
      ),
    );
  }
}
