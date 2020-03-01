// 视频播放
import 'package:flutter/material.dart';
import 'package:commerce_shop_flutter/components/common/top_title.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';

class Monitor extends StatefulWidget {
  @override
  _MonitorState createState() => _MonitorState();
}

class _MonitorState extends State<Monitor> {
  VideoPlayerController videoPlayerController;
  ChewieController chewieController;
  @override
  void initState() {
    super.initState();
    videoPlayerController = VideoPlayerController.network(
        'https://greenadoption.cn/tempImages/example.mp4');

    chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      aspectRatio: 3 / 2,
      autoPlay: true,
      looping: true,
    );
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: ListView(
          children: <Widget>[
            // 标题
            TopTitle(title: '实时监控', showArrow: true),
            Chewie(
              controller: chewieController,
            ),
            RaisedButton(
              child: Text("切换视频"),
              onPressed: () {
                videoPlayerController.pause();
                setState(() {
                  videoPlayerController = VideoPlayerController.network(
                      'https://www.runoob.com/try/demo_source/mov_bbb.mp4');
                  chewieController = ChewieController(
                    videoPlayerController: videoPlayerController,
                    aspectRatio: 3 / 2,
                    autoPlay: true,
                    looping: true,
                  );
                });
              },
            )
          ],
        ),
      ),
    );
  }
}
