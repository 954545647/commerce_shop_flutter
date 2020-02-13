// 热点新闻
import 'package:flutter/material.dart';
import 'package:commerce_shop_flutter/components/common/top_title.dart';
// import 'package:flutter_custom_calendar/flutter_custom_calendar.dart';
// import 'package:commerce_shop_flutter/utils/dio.dart';
import 'package:commerce_shop_flutter/utils/http.dart';
import 'package:commerce_shop_flutter/utils/utils.dart';

class HotNews extends StatefulWidget {
  @override
  _HotNewsState createState() => _HotNewsState();
}

class _HotNewsState extends State<HotNews> {
  List integralList = [];
  @override
  void initState() {
    super.initState();
    getData("news").then((val) {
      print(val);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: ListView(
          children: <Widget>[
            // 积分标题
            TopTitle(title: '热点新闻', showArrow: true),
            // 积分详情
            // integralDetail(),
          ],
        ),
      ),
      // 顶部商品展示
    );
  }

  Widget integralDetail() {
    print(integralList.length);
    if (integralList.length > 0) {
      return Container(
        child: Column(
          children: integralList.map((item) {
            return integralItem(item);
          }).toList(),
        ),
      );
    } else {
      return Text("暂无数据");
    }
  }

  Widget integralItem(data) {
    var source = data["source"];
    return Container(
      height: 60.0,
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(width: 1, color: Colors.grey))),
      padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
              margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: Text(judgeIntegralSource(source))),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(sourcePoint(source)),
              SizedBox(
                height: 5,
              ),
              Text(parseSingleTime(data["createdAt"]))
            ],
          )
        ],
      ),
    );
  }
}
