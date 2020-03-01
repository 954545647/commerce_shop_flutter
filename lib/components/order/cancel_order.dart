// 已取消订单页
import 'package:flutter/material.dart';
import 'package:commerce_shop_flutter/utils/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:commerce_shop_flutter/components/common/top_title.dart';
import 'package:commerce_shop_flutter/utils/utils.dart';

class CancelOrder extends StatefulWidget {
  @override
  _CancelOrderState createState() => _CancelOrderState();
}

class _CancelOrderState extends State<CancelOrder> {
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
          if (data["status"] == 3) {
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
            TopTitle(title: "已失效", showArrow: true),
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
        list.add(orderItem(orderList[i]));
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

  Widget orderItem(data) {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
      padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), color: Colors.white),
      child: Column(children: goodList(data, data["Order_Details"])),
    );
  }

  goodList(orderInfo, orderDetail) {
    List<Widget> list = [];
    for (int i = 0; i < orderDetail.length; i++) {
      list.add(goodItem(orderInfo, orderDetail[i], orderDetail.length, i));
    }
    return list;
  }

  Widget goodItem(orderInfo, orderDetail, len, index) {
    return Container(
      height: len > 1 ? double.parse("${len * 60}") : 150,
      child: Row(
        children: <Widget>[
          Image.network(
            orderDetail["good_cover"],
            width: 140,
            height: 100,
            fit: BoxFit.fill,
          ),
          SizedBox(width: 50),
          Stack(
            children: <Widget>[
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
                  SizedBox(height: 20),
                  index + 1 == len ? Text("下单时间:") : Text(""),
                  index + 1 == len
                      ? Text("${parseDetailTime(orderInfo["createdAt"])}")
                      : Text("")
                ],
              ),
              Positioned(
                right: 20,
                top: 20,
                child: Container(
                  width: 50,
                  height: 50,
                  child: Icon(
                    IconData(0xe60f, fontFamily: 'myIcons'),
                    size: 80,
                    color: Colors.grey,
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}