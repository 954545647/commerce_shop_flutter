// 视频播放
import 'package:flutter/material.dart';
import 'package:commerce_shop_flutter/components/common/top_title.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
// import 'package:flutter_ijkplayer/flutter_ijkplayer.dart';
// import 'dart:async';
import 'package:commerce_shop_flutter/utils/dio.dart';

class Monitor extends StatefulWidget {
  @override
  _MonitorState createState() => _MonitorState();
}

class _MonitorState extends State<Monitor> {
  List farmInfo = [];
  List monitorList = [];
  VideoPlayerController videoPlayerController;
  ChewieController chewieController;
  // IjkMediaController controller = IjkMediaController();
  // String tmpt1 = "rtmp://202.69.69.180:443/webcast/bshdlive-pccaidi";
  // String tmpt2 = "rtmp://202.69.69.180:443/webcast/bshdlive-pc";
  // bool loading = true;
  @override
  void initState() {
    super.initState();
    getAllFarms();
    // videoPlayerController = VideoPlayerController.network(
    //     'https://greenadoption.cn/tempImages/example.mp4');

    // chewieController = ChewieController(
    //   videoPlayerController: videoPlayerController,
    //   aspectRatio: 2,
    //   autoPlay: true,
    //   looping: true,
    // );
    // this.initPlayer();
  }

// 获取农场全部信息
  getAllFarms() {
    DioUtils.getInstance().get("getAllFarmsInfo").then((val) {
      if (val != null && val["data"] != null) {
        val["data"].forEach((item) {
          var cur = item["farmInfo"];
          monitorList.add(new VideoPlayerController.network(cur["monitor"]));
        });
        if (mounted) {
          setState(() {
            farmInfo = val["data"];
          });
        }
      }
    });
  }

  initPlayer() async {
    // await controller.setNetworkDataSource(
    //     'rtmp://202.69.69.180:443/webcast/bshdlive-pc',
    //     autoPlay: true);
    // await controller.play();
  }

  @override
  void dispose() {
    videoPlayerController?.dispose();
    chewieController?.dispose();
    // controller.dispose();
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
            // Container(
            //   height: 200, // 设置高度
            //   child: IjkPlayer(mediaController: controller),
            // ),
            farmList(),
          ],
        ),
      ),
    );
  }

  Widget farmList() {
    List<Widget> list = [];
    for (var i = 0; i < farmInfo.length; i++) {
      list.add(farmItem(farmInfo[i], i));
    }
    return Column(children: list);
  }

  Widget farmItem(data, index) {
    var cur = data["farmInfo"];
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, "farmDetail", arguments: cur);
      },
      child: Container(
        height: 300,
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
              alignment: Alignment.center,
              height: 30,
              child: Text(
                cur["farmName"],
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, "farmDetail", arguments: cur);
              },
              child: Container(
                height: 200,
                child: Chewie(
                    controller: ChewieController(
                  videoPlayerController: monitorList[index],
                  aspectRatio: 2,
                  autoPlay: true,
                  looping: false,
                )),
              ),
            )
          ],
        ),
      ),
    );
  }
}
