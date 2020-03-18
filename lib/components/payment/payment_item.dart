// 通用标题
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import "package:commerce_shop_flutter/config/config.dart";

class OrderItem extends StatelessWidget {
  final data;
  OrderItem(this.data);

  @override
  Widget build(BuildContext context) {
    final String goodName = data["goodName"];
    final String price = data["price"];
    final String imgCover = data["imgCover"];
    final int count = data["count"]; // 当前商品的数量
    return Container(
      height: 130,
      width: ScreenUtil().setWidth(750),
      margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Image.network(
            "${Config.apiHost}/$imgCover",
            fit: BoxFit.fill,
            width: 150,
            height: 100,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(goodName),
              Container(
                width: ScreenUtil().setWidth(300),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Text("￥$price"),
                    Text("x${count.toString()}"),
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
