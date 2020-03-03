import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class GoodBanner extends StatefulWidget {
  final List imageList;
  final int height;
  final double fraction; // 水平缩放
  final double scale; // 立体缩放
  final double topMargin; // 头部间距
  GoodBanner(
      {this.imageList,
      this.height = 400,
      this.fraction = 1.0,
      this.scale = 1.0,
      this.topMargin = 0});
  @override
  _GoodBannerState createState() => _GoodBannerState(
      imageList: imageList,
      height: height,
      fraction: fraction,
      scale: scale,
      topMargin: topMargin);
}

class _GoodBannerState extends State<GoodBanner> {
  final List imageList;
  final int height;
  final double fraction;
  final double scale;
  final double topMargin;
  _GoodBannerState(
      {this.imageList, this.height, this.fraction, this.scale, this.topMargin});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: topMargin),
      height: ScreenUtil().setHeight(height),
      child: Swiper(
        itemBuilder: (BuildContext context, int index) {
          return Image.network(
            '${imageList[index]}',
            fit: BoxFit.fill,
          );
        },
        autoplay: true,
        itemCount: imageList.length,
        viewportFraction: fraction,
        scale: scale,
        pagination: new SwiperPagination(),
      ),
    );
  }
}
