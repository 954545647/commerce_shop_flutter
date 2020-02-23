// 订单主页
import 'package:flutter/material.dart';
// import 'package:commerce_shop_flutter/utils/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:commerce_shop_flutter/components/common/top_title.dart';

class AllOrder extends StatefulWidget {
  @override
  _AllOrderState createState() => _AllOrderState();
}

class _AllOrderState extends State<AllOrder> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            TopTitle(title: "全部订单", showArrow: true),
            Text("444")
          ],
        ),
      )),
    );
  }
}
