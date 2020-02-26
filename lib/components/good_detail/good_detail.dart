import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// 商品价格+简介+销量信息
Widget goodDetail(argument) {
  return Container(
    color: Colors.white,
    child: Column(
      children: <Widget>[
        // 商品价格+关注+降价通知
        gooodPrice(argument),
        // 商品简介
        goodDesc(argument),
        // 商品销量
        goodSales(argument)
      ],
    ),
  );
}

// 商品价格
Widget gooodPrice(argument) {
  return Container(
    height: ScreenUtil().setHeight(130),
    padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text.rich(TextSpan(children: [
          TextSpan(
              text: '￥',
              style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.red,
                  fontWeight: FontWeight.bold)),
          TextSpan(
              text: argument['price'].toString(),
              style: TextStyle(
                  fontSize: 30.0,
                  color: Colors.red,
                  fontWeight: FontWeight.bold))
        ])),
        Container(
          child: Row(
            children: <Widget>[
              InkWell(
                child: Column(
                  children: <Widget>[
                    Icon(IconData(0xe628, fontFamily: 'myIcons'), size: 22),
                    SizedBox(height: 2),
                    Text('降价通知')
                  ],
                ),
              ),
              SizedBox(width: 10),
              InkWell(
                  child: Column(
                children: <Widget>[
                  Icon(IconData(0xe60a, fontFamily: 'myIcons'), size: 22),
                  SizedBox(height: 2),
                  Text('关注')
                ],
              ))
            ],
          ),
        )
      ],
    ),
  );
}

// 商品简介
Widget goodDesc(argument) {
  return Container(
    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
    child: Text(
      argument['descript'].toString(),
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    ),
  );
}

// 商品销量
Widget goodSales(argument) {
  String carriage =
      argument["expressCost"] == 0 ? '0' : argument["expressCost"].toString();
  String sales = argument["sales"].toString();
  return Container(
    height: ScreenUtil().setHeight(80),
    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          '快递:$carriage',
          style: TextStyle(color: Color.fromRGBO(139, 133, 133, 1)),
        ),
        Text('月销:$sales',
            style: TextStyle(color: Color.fromRGBO(139, 133, 133, 1))),
        Text(argument["from"].toString(),
            style: TextStyle(color: Color.fromRGBO(139, 133, 133, 1)))
      ],
    ),
  );
}
