// 订单主页
import 'package:flutter/material.dart';
import 'package:commerce_shop_flutter/utils/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:commerce_shop_flutter/components/common/top_title.dart';
// import 'package:commerce_shop_flutter/utils/utils.dart';
import "package:commerce_shop_flutter/config/config.dart";
// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:commerce_shop_flutter/provider/supplierData.dart';
import 'package:commerce_shop_flutter/utils/utils.dart';

class OrderManageDetail extends StatefulWidget {
  @override
  _OrderManageDetailState createState() => _OrderManageDetailState();
}

class _OrderManageDetailState extends State<OrderManageDetail> {
  SupplierData supplierData;
  List orderData = []; // 全部订单
  List unpayOrders = []; // 未支付订单
  List goodOrders = []; // 认养订单
  List farmOrders = []; // 租地订单
  @override
  void initState() {
    super.initState();
    _initSupplierData();
  }

  // 初始化商家订单
  Future<void> _initSupplierData() async {
    await Future.delayed(Duration(microseconds: 300), () async {
      supplierData = Provider.of<SupplierData>(context);
      await getOrders();
    });
  }

  // 获取全部订单
  getOrders() async {
    int type = ModalRoute.of(context).settings.arguments;
    // 未支付订单
    if (type == 1) {
      var data = await DioUtil.getInstance(context).get("SunpayOrders");
      if (data != null) {
        orderData = data["data"];
        setState(() {});
      }
    } else {
      await DioUtil.getInstance(context).post("SsupplierOrders",
          data: {"supplierId": supplierData.supplierInfo.id}).then((val) {
        if (val != null && val["data"] != null) {
          // 全部订单
          if (type == 0) {
            goodOrders = val["data"]["goodOrderList"];
            farmOrders = val["data"]["farmOrderList"];
          }
          // 商品订单
          if (type == 2) {
            orderData = val["data"]["goodOrderList"];
          }
          // 租地订单
          if (type == 3) {
            orderData = val["data"]["farmOrderList"];
          }
          setState(() {});
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    int type = ModalRoute.of(context).settings.arguments;
    return Scaffold(
        body: MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: Container(
        child: ListView(
          children: <Widget>[
            TopTitle(
              title: "订单详情",
              showArrow: true,
              ifRefresh: true,
            ),
            showOrder(type)
          ],
        ),
      ),
    ));
  }

  showOrder(type) {
    if (type == 0) {
      return Container(
        child: Column(
          children: <Widget>[orderLists(goodOrders), farmOrder(farmOrders)],
        ),
      );
    }
    if (type == 1) {
      return orderLists(orderData);
    }
    if (type == 2) {
      return orderLists(orderData);
    }
    if (type == 3) {
      return farmOrder(orderData);
    }
  }

  // 认养订单
  Widget orderLists(orderData) {
    List<Widget> list = [];
    if (orderData.length > 0) {
      for (var i = 0; i < orderData.length; i++) {
        list.add(orderItem(orderData[i]));
      }
      list.add(SizedBox(height: 30));
      return Column(
        children: list,
      );
    } else {
      return Container(
        alignment: Alignment.center,
        height: 50,
        child: Text("暂无订单"),
      );
    }
  }

  Widget orderItem(data) {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), color: Colors.white),
      child: Column(children: orderList(data, data["Order_Details"])),
    );
  }

  List<Widget> orderList(orderInfo, orderDetail) {
    List<Widget> list = [];
    for (int i = 0; i < orderDetail.length; i++) {
      list.add(
          orderItemDetails(orderInfo, orderDetail[i], orderDetail.length, i));
    }
    return list;
  }

  Widget orderItemDetails(orderInfo, orderDetail, len, index) {
    return Container(
      padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
      height: len > 1 ? double.parse("${len * 60}") : 150,
      child: Row(
        children: <Widget>[
          Image.network(
            "${Config.apiHost}/${orderDetail["good_cover"]}",
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

  // 租地订单
  Widget farmOrder(farmOrders) {
    List<Widget> list = [];
    if (farmOrders.length > 0) {
      for (var i = 0; i < farmOrders.length; i++) {
        list.add(farmList(farmOrders[i]));
      }
      list.add(SizedBox(height: 30));
      return Column(
        children: list,
      );
    } else {
      return Container(
        alignment: Alignment.center,
        height: 50,
        child: Text("暂无租地订单"),
      );
    }
  }

  Widget farmList(data) {
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
