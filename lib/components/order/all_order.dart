// 订单主页
import 'package:flutter/material.dart';
import 'package:commerce_shop_flutter/utils/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:commerce_shop_flutter/components/common/top_title.dart';
import 'package:commerce_shop_flutter/utils/utils.dart';

class AllOrder extends StatefulWidget {
  @override
  _AllOrderState createState() => _AllOrderState();
}

class _AllOrderState extends State<AllOrder> {
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
        orderList = val["data"];
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
            TopTitle(title: "全部订单", showArrow: true),
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
        alignment: Alignment.center,
        height: 500,
        child: Text("暂无订单"),
      );
    }
  }

  Widget orderItem(data) {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
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
      padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
      height: len > 1 ? double.parse("${len * 60}") : 150,
      child: Row(
        children: <Widget>[
          Image.network(
            orderDetail["good_cover"],
            width: 140,
            height: 100,
            fit: BoxFit.fill,
          ),
          SizedBox(width: 40),
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
                      Text(
                        "x${orderDetail["good_count"]}",
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(
                        width: 20,
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
              // 已经取消
              orderInfo["status"] == 1 && index + 1 == len
                  ? Positioned(
                      right: 30,
                      top: 20,
                      child: Container(
                        width: 50,
                        height: 50,
                        child: Icon(
                          IconData(0xe644, fontFamily: 'myIcons'),
                          size: 80,
                          color: Colors.blue,
                        ),
                      ),
                    )
                  // 已经完成

                  // 失效
                  : orderInfo["status"] == 3 && index + 1 == len
                      ? Positioned(
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
                      : Container(height: 0.0, width: 0.0)
            ],
          )
        ],
      ),
    );
  }
}
