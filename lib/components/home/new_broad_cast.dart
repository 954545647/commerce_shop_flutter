import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:commerce_shop_flutter/utils/dio.dart';

class NewBroadCast extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: DioUtils.getInstance().get('homeNewsList'),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          } else {
            var newList = snapshot.data['data']['newsList'];
            return Container(
              width: ScreenUtil.getInstance().setWidth(750),
              height: ScreenUtil.getInstance().setHeight(120),
              margin: EdgeInsets.fromLTRB(0, 10.0, 0, 0.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[leftNew(), rightNew(newList)],
              ),
            );
          }
        } else {
          return Center(child: CircularProgressIndicator()); // 请求未结束，显示loading
        }
      },
    );
  }

  // 左侧标题
  Widget leftNew() {
    return Container(
        padding: EdgeInsets.only(right: 5.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '农场',
              style:
                  TextStyle(backgroundColor: Color.fromRGBO(54, 159, 144, 1)),
            ),
            Text('快报')
          ],
        ));
  }

  // 右侧新闻
  Widget rightNew(list) {
    return Container(
      width: ScreenUtil().setWidth(620),
      alignment: Alignment.center,
      child: Swiper(
        itemBuilder: (BuildContext context, int index) {
          return newItem(list[index]);
        },
        itemCount: 4,
        scrollDirection: Axis.vertical,
        autoplay: true,
      ),
    );
  }

  // 新闻子项
  Widget newItem(item) {
    return Container(
        padding: EdgeInsets.fromLTRB(5, 0, 0, 5),
        child: Center(
          child: Text(
            item,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ));
  }
}
