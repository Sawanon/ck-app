import 'dart:io';

import 'package:byteplus_vod/ve_vod.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lottery_ck/utils.dart';

// class VideoToomany extends StatelessWidget {
//   const VideoToomany({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Text("data"),
//       ),
//     );
//   }
// }

class VideoToomany extends StatefulWidget {
  const VideoToomany({super.key});

  @override
  State<VideoToomany> createState() => _VideoToomanyState();
}

class _VideoToomanyState extends State<VideoToomany> {
  TTVideoPlayerView? playerView;
  VodPlayerFlutter player = VodPlayerFlutter();
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
  }

  void setSource() async {
    TTVideoEngineUrlSource source = TTVideoEngineUrlSource.initWithURL(
      'https://demovod.mylaos.life/83b83759f2264edeaf0e62cffd250028/master.m3u8?auth_key=1739336478-d333ebeafbe04905a5332d048b570d2c-0-0477f86a0edc0377115555711babdf58',
      'horoscope',
    );
    // TTVideoEngineVidSource source = TTVideoEngineVidSource.init(
    //   vid: 'v11263g50000ctba40vak5v37c0epvlg',
    //   playAuthToken: '',
    // );
    await player.setMediaSource(source);
    await player.play();
  }

  @override
  void initState() {
    setup();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // if (playerView != null) {
    //   return Scaffold(
    //     body: playerView,
    //   );
    // }
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () {
                setSource();
              },
              child: Text('setSource'),
            ),
            playerView != null
                ? Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      color: Colors.red.shade200,
                      child: playerView!,
                    ),
                  )
                : const Center(
                    child: CircularProgressIndicator(
                      color: Colors.black,
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
