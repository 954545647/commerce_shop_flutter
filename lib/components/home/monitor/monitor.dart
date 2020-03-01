// 视频播放
import 'package:flutter/material.dart';
import 'package:commerce_shop_flutter/components/common/top_title.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_ijkplayer/flutter_ijkplayer.dart';
// import 'dart:async';

class Monitor extends StatefulWidget {
  @override
  _MonitorState createState() => _MonitorState();
}

class _MonitorState extends State<Monitor> {
  VideoPlayerController videoPlayerController;
  ChewieController chewieController;
  IjkMediaController controller = IjkMediaController();
  String tmpt1 = "rtmp://202.69.69.180:443/webcast/bshdlive-pccaidi";
  String tmpt2 = "rtmp://202.69.69.180:443/webcast/bshdlive-pc";
  // bool loading = true;
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
    this.initPlayer();
  }

  initPlayer() async {
    await controller.setNetworkDataSource(
        'rtmp://202.69.69.180:443/webcast/bshdlive-pc',
        autoPlay: true);
    await controller.play();
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    chewieController.dispose();
    controller.dispose();
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
            ),
            Container(
              height: 200, // 设置高度
              child: IjkPlayer(mediaController: controller),
            ),
          ],
        ),
      ),
    );
  }
}
