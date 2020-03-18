import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:commerce_shop_flutter/utils/dio.dart';

class HomeSwiper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: DioUtil.getInstance(context).get('homeSwiperImgList'),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          } else {
            if (snapshot.data != null &&
                snapshot.data["data"] != null &&
                snapshot.data["data"]["swiperImgList"] != null) {
              var homeSwiperData = snapshot.data['data']['swiperImgList'];
              return Container(
                width: ScreenUtil.getInstance().setWidth(750),
                height: ScreenUtil.getInstance().setHeight(420),
                child: new Swiper(
                  itemBuilder: (BuildContext context, int index) {
                    return new Image.network(
                      '${homeSwiperData[index]['url']}',
                      fit: BoxFit.fill,
                    );
                  },
                  itemCount: homeSwiperData.length,
                  pagination: new SwiperPagination(),
                ),
              );
            } else {
              return Text("");
            }
          }
        } else {
          return Text(""); // 请求未结束，显示loading
        }
      },
    );
  }
}
