import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:dio/dio.dart';
import 'dart:convert';

class NewBroadCast extends StatefulWidget {
  @override
  _NewBroadCastState createState() => _NewBroadCastState();
}

class _NewBroadCastState extends State<NewBroadCast> {
  String cityName = "";
  List weatherList = [];
  @override
  void initState() {
    super.initState();
    getWeather();
  }

  Future<void> getWeather() async {
    var data = await new Dio().get(
        "https://tianqiapi.com/api?version=v1&appid=85861573&appsecret=DEayWu5Y");
    var weather = jsonDecode(data.toString());
    cityName = weather["city"];
    weatherList = weather["data"];
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (cityName != "") {
      return Container(
        width: ScreenUtil.getInstance().setWidth(750),
        height: ScreenUtil.getInstance().setHeight(120),
        margin: EdgeInsets.fromLTRB(0, 10.0, 0, 0.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[leftNew(), rightNew(weatherList)],
        ),
      );
    } else {
      return Container(
        width: ScreenUtil.getInstance().setWidth(750),
        height: ScreenUtil.getInstance().setHeight(120),
        margin: EdgeInsets.fromLTRB(0, 10.0, 0, 0.0),
        child: Text(""),
      );
    }
  }

  // 左侧标题
  Widget leftNew() {
    return Container(
        padding: EdgeInsets.only(right: 5.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '天气',
              style:
                  TextStyle(backgroundColor: Color.fromRGBO(54, 159, 144, 1)),
            ),
            Text('预报')
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
        itemCount: list.length,
        scrollDirection: Axis.vertical,
        autoplay: true,
      ),
    );
  }

  // 新闻子项
  Widget newItem(item) {
    // String res =
    String day = item["day"];
    String date = item["date"];
    String wea = item["wea"];
    return Container(
        padding: EdgeInsets.fromLTRB(5, 0, 0, 5),
        child: Center(
          child: Text(
            "$cityName $day  $date  $wea",
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ));
  }
}
