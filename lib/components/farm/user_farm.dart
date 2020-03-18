// 我的土地
import 'package:flutter/material.dart';
import 'package:commerce_shop_flutter/utils/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:commerce_shop_flutter/components/common/top_title.dart';
import 'package:commerce_shop_flutter/utils/utils.dart';
import "package:commerce_shop_flutter/config/config.dart";

class MyFarm extends StatefulWidget {
  @override
  _MyFarmState createState() => _MyFarmState();
}

class _MyFarmState extends State<MyFarm> {
  List farmList = [];
  @override
  void initState() {
    super.initState();
    getMyFarms();
  }

  // 获取全部订单
  getMyFarms() {
    DioUtil.getInstance(context).get("myFarms").then((val) {
      if (val != null && val["data"] != null) {
        farmList = val["data"];
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
            TopTitle(title: "我的土地", showArrow: true),
            myFarm()
          ],
        ),
      ),
    ));
  }

  Widget myFarm() {
    List<Widget> list = [];
    if (farmList.length > 0) {
      for (var i = 0; i < farmList.length; i++) {
        list.add(farmItem(farmList[i]));
      }
      list.add(SizedBox(height: 30));
      return Column(
        children: list,
      );
    } else {
      return Container(
        alignment: Alignment.center,
        height: 500,
        child: Text("暂无租地"),
      );
    }
  }

  Widget farmItem(data) {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), color: Colors.white),
      child: Column(children: farmInfo(data, data["Farm_Order_Details"])),
    );
  }

  farmInfo(orderInfo, orderDetail) {
    List<Widget> list = [];
    for (int i = 0; i < orderDetail.length; i++) {
      list.add(farmItemInfo(orderInfo, orderDetail[i], orderDetail.length, i));
    }
    return list;
  }

  Widget farmItemInfo(orderInfo, orderDetail, len, index) {
    return Container(
      padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
      height: len > 1 ? double.parse("${len * 60}") : 150,
      child: Row(
        children: <Widget>[
          Image.network(
            "${Config.apiHost}/${orderDetail["crop_cover"]}",
            width: 140,
            height: 100,
            fit: BoxFit.fill,
          ),
          SizedBox(width: 50),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(
                    orderDetail["crop_name"],
                    style: TextStyle(fontSize: 20),
                  ),
                  Text(
                    "x${orderDetail["crop_count"]}",
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  Text(
                    "￥${orderDetail["crop_price"]}",
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
          )
        ],
      ),
    );
  }
}
