// 订单主页
import 'package:flutter/material.dart';
import 'package:commerce_shop_flutter/utils/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:commerce_shop_flutter/components/common/top_title.dart';
import 'package:commerce_shop_flutter/components/order/unpay_dialog.dart';
import 'package:commerce_shop_flutter/utils/utils.dart';
import "package:commerce_shop_flutter/config/config.dart";

class UnpayOrder extends StatefulWidget {
  @override
  _UnpayOrderState createState() => _UnpayOrderState();
}

class _UnpayOrderState extends State<UnpayOrder> {
  List orderList = [];
  @override
  void initState() {
    super.initState();
    getOrders();
  }

  // 获取全部订单
  getOrders() {
    DioUtils.getInstance().get("allOrders").then((val) {
      if (val != null && val["data"] != null) {
        val["data"].forEach((data) {
          if (data["status"] == 1) {
            orderList.add(data);
          }
        });
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: Container(
        child: ListView(
          children: <Widget>[
            TopTitle(title: "代付款", showArrow: true, ifRefresh: true),
            orderLists()
          ],
        ),
      ),
    ));
  }

  Widget orderLists() {
    List<Widget> list = [];
    if (orderList.length > 0) {
      for (var i = 0; i < orderList.length; i++) {
        list.add(orderItem(orderList[i], i));
      }
      list.add(SizedBox(height: 30));
      return Column(
        children: list,
      );
    } else {
      return Container(
        height: 500,
        alignment: Alignment.center,
        child: Text("暂无订单"),
      );
    }
  }

  Widget orderItem(data, curIndex) {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
      padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), color: Colors.white),
      child: Column(children: goodList(data, data["Order_Details"], curIndex)),
    );
  }

  goodList(orderInfo, orderDetail, curIndex) {
    List<Widget> list = [];
    for (int i = 0; i < orderDetail.length; i++) {
      list.add(
          goodItem(orderInfo, orderDetail[i], orderDetail.length, i, curIndex));
    }
    return list;
  }

  Widget goodItem(orderInfo, orderDetail, len, index, curIndex) {
    return GestureDetector(
      onTap: () {
        showDialog(
            context: context,
            builder: (context) {
              return UnpayDialog(
                  title: "订单详情", data: orderInfo, curItem: curIndex);
            });
      },
      child: Container(
        height: len > 1 ? double.parse("${len * 60}") : 150,
        child: Row(
          children: <Widget>[
            Image.network(
              "${Config.apiHost}${orderDetail["good_cover"]}",
              width: 140,
              height: 100,
              fit: BoxFit.fill,
            ),
            SizedBox(width: 40),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(
                      orderDetail["good_name"],
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    Text(
                      "￥${orderDetail["good_price"]}",
                      style: TextStyle(fontSize: 20, color: Colors.red),
                    ),
                  ],
                ),
                index + 1 == len ? Text("下单时间:") : Text(""),
                index + 1 == len
                    ? Text("${parseDetailTime(orderInfo["createdAt"])}")
                    : Text(""),
                index + 1 == len ? Text("过期时间:") : Text(""),
                index + 1 == len
                    ? Text(
                        "${pastTime(orderInfo["createdAt"])}",
                        style: TextStyle(color: Colors.red),
                      )
                    : Text(""),
              ],
            )
          ],
        ),
      ),
    );
  }
}
