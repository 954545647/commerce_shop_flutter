import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class GoodBanner extends StatefulWidget {
  final List imageList;
  GoodBanner({this.imageList});
  @override
  _GoodBannerState createState() => _GoodBannerState(imageList: imageList);
}

class _GoodBannerState extends State<GoodBanner> {
  final List imageList;
  _GoodBannerState({this.imageList});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil().setHeight(400),
      child: Swiper(
        itemBuilder: (BuildContext context, int index) {
          return Image.asset(
            '${imageList[index]}',
            fit: BoxFit.fill,
          );
        },
        itemCount: imageList.length,
        pagination: new SwiperPagination(),
      ),
    );
  }
}
