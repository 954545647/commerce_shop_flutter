import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:commerce_shop_flutter/components/common/menuIcon.dart';
import 'package:provider/provider.dart';
import 'package:commerce_shop_flutter/provider/userData.dart';
import 'package:commerce_shop_flutter/utils/dio.dart';

class OrderList extends StatefulWidget {
  @override
  _OrderListState createState() => _OrderListState();
}

class _OrderListState extends State<OrderList> {
  List orderList = []; // 全部订单
  List unpayOrders = []; // 未支付订单
  List pastOrders = []; // 过期订单
  List finishOrders = []; // 完成订单
  @override
  void initState() {
    super.initState();
    getOrders();
  }

  // 获取全部订单
  getOrders() {
    DioUtils.getInstance().get("allOrders").then((val) {
      if (val != null && val["data"] != null) {
        unpayOrders = [];
        pastOrders = [];
        finishOrders = [];
        val["data"].forEach((data) {
          if (data["status"] == 1) {
            unpayOrders.add(data);
          }
          if (data["status"] == 3) {
            pastOrders.add(data);
          }
          if (data["status"] == 2) {
            finishOrders.add(data);
          }
        });
        orderList = val["data"];
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserData>(context);
    bool isLogin = user.isLogin;
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
      width: ScreenUtil().setWidth(750),
      height: ScreenUtil().setHeight(170),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10.0)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          GestureDetector(
              child: Stack(
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(MenuIcons.allOrder, size: 25),
                      Text(
                        '全部订单',
                        style: TextStyle(fontSize: 16.0),
                      )
                    ],
                  ),
                  Positioned(
                      right: 0,
                      top: 5,
                      child: orderList.length > 0 && isLogin
                          ? Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(50),
                              ),
                              height: 20,
                              width: 20,
                              child: Text(
                                orderList.length.toString(),
                                style: TextStyle(color: Colors.white),
                              ),
                            )
                          : Container(height: 0.0, width: 0.0))
                ],
              ),
              onTap: () {
                isLogin
                    ? Navigator.pushNamed(context, "allOrder",
                        arguments: pastOrders)
                    : Navigator.pushNamed(context, "login");
              }),
          GestureDetector(
              child: Stack(
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(MenuIcons.payment, size: 25),
                      Text(
                        '待付款',
                        style: TextStyle(fontSize: 16.0),
                      )
                    ],
                  ),
                  Positioned(
                      right: 0,
                      top: 5,
                      child: unpayOrders.length > 0 && isLogin
                          ? Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(50),
                              ),
                              height: 20,
                              width: 20,
                              child: Text(
                                unpayOrders.length.toString(),
                                style: TextStyle(color: Colors.white),
                              ),
                            )
                          : Container(height: 0.0, width: 0.0))
                ],
              ),
              onTap: () {
                isLogin
                    ? Navigator.pushNamed(context, "unpayOrder").then((val) {
                        if (val) {
                          getOrders();
                        }
                      })
                    : Navigator.pushNamed(context, "login");
              }),
          GestureDetector(
              child: Stack(
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(MenuIcons.delivered, size: 25),
                      Text(
                        '已完成',
                        style: TextStyle(fontSize: 16.0),
                      )
                    ],
                  ),
                  Positioned(
                      right: 0,
                      top: 5,
                      child: finishOrders.length > 0 && isLogin
                          ? Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(50),
                              ),
                              height: 20,
                              width: 20,
                              child: Text(
                                finishOrders.length.toString(),
                                style: TextStyle(color: Colors.white),
                              ),
                            )
                          : Container(height: 0.0, width: 0.0))
                ],
              ),
              onTap: () {
                isLogin
                    ? Navigator.pushNamed(context, "finishOrder")
                    : Navigator.pushNamed(context, "login");
              }),
          GestureDetector(
              child: Stack(
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(MenuIcons.delivered, size: 25),
                      Text(
                        '已取消',
                        style: TextStyle(fontSize: 16.0),
                      )
                    ],
                  ),
                  Positioned(
                      right: 0,
                      top: 5,
                      child: pastOrders.length > 0 && isLogin
                          ? Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(50),
                              ),
                              height: 20,
                              width: 20,
                              child: Text(
                                pastOrders.length.toString(),
                                style: TextStyle(color: Colors.white),
                              ),
                            )
                          : Container(height: 0.0, width: 0.0))
                ],
              ),
              onTap: () {
                isLogin
                    ? Navigator.pushNamed(context, "cancelOrder")
                    : Navigator.pushNamed(context, "login");
              }),
        ],
      ),
    );
  }
}
