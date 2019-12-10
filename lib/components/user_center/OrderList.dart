import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:commerce_shop_flutter/components/common/menuIcon.dart';

class OrderList extends StatefulWidget {
  @override
  _OrderListState createState() => _OrderListState();
}

class _OrderListState extends State<OrderList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
      width: ScreenUtil().setWidth(750),
      height: ScreenUtil().setHeight(170),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10.0)),
      child: Row(
        children: <Widget>[
          Expanded(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(MenuIcons.allOrder, size: 25),
              Text(
                '全部订单',
                style: TextStyle(fontSize: 16.0),
              )
            ],
          )),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(MenuIcons.payment, size: 25),
                Text(
                  '代付款',
                  style: TextStyle(fontSize: 16.0),
                )
              ],
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(MenuIcons.delivered, size: 26),
                Text(
                  '待收货',
                  style: TextStyle(fontSize: 16.0),
                )
              ],
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(MenuIcons.evaluated, size: 24),
                Text(
                  '待评价',
                  style: TextStyle(fontSize: 16.0),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
