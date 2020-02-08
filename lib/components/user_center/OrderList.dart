import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:commerce_shop_flutter/components/common/menuIcon.dart';
import 'package:provider/provider.dart';
import 'package:commerce_shop_flutter/provider/userData.dart';

class OrderList extends StatefulWidget {
  @override
  _OrderListState createState() => _OrderListState();
}

class _OrderListState extends State<OrderList> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserData>(context);
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
              child: GestureDetector(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(MenuIcons.allOrder, size: 25),
                      Text(
                        '全部订单',
                        style: TextStyle(fontSize: 16.0),
                      )
                    ],
                  ),
                  onTap: () {
                    user.isLogin
                        ? print("已经登录")
                        : Navigator.pushNamed(context, "login");
                  })),
          Expanded(
            child: GestureDetector(
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
              onTap: () {
                user.isLogin
                    ? print("已经登录")
                    : Navigator.pushNamed(context, "login");
              },
            ),
          ),
          Expanded(
            child: GestureDetector(
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
              onTap: () {
                user.isLogin
                    ? print("已经登录")
                    : Navigator.pushNamed(context, "login");
              },
            ),
          ),
          Expanded(
            child: GestureDetector(
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
              onTap: () {
                user.isLogin
                    ? print("已经登录")
                    : Navigator.pushNamed(context, "login");
              },
            ),
          )
        ],
      ),
    );
  }
}
