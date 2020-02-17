import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// 商品销量
Widget goodSales(argument) {
  var carriage = argument['expressCost'] == 0 ? '免运费' : argument['expressCost'];
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
        Text('月销:${argument['sales']}',
            style: TextStyle(color: Color.fromRGBO(139, 133, 133, 1))),
        Text(argument['from'],
            style: TextStyle(color: Color.fromRGBO(139, 133, 133, 1)))
      ],
    ),
  );
}
