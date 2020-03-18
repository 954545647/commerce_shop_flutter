import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:commerce_shop_flutter/utils/dio.dart';
import 'package:provider/provider.dart';
import 'package:commerce_shop_flutter/provider/supplierData.dart';

class OrderManage extends StatefulWidget {
  // OrderManage(this.info);
  // final info;
  @override
  _OrderManageState createState() => _OrderManageState();
}

class _OrderManageState extends State<OrderManage> {
  List orderList = []; // 全部订单
  List unpayOrders = []; // 未支付订单
  List goodOrders = []; // 认养订单
  List farmOrders = []; // 租地订单
  int unpayNum = 0;
  int goodOrderNum = 0;
  SupplierData supplierData;
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
  getOrders() {
    DioUtil.getInstance(context).post("SsupplierOrders",
        data: {"supplierId": supplierData.supplierInfo.id}).then((val) {
      if (val != null && val["data"] != null) {
        var data = val["data"];
        unpayNum = 0;
        goodOrderNum = 0;
        goodOrders = data["goodOrderList"];
        farmOrders = data["farmOrderList"];
        goodOrders.forEach((item) {
          if (item["status"] == 1) {
            unpayNum++;
          } else {
            goodOrderNum++;
          }
        });
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
      width: ScreenUtil().setWidth(750),
      height: ScreenUtil().setHeight(240),
      decoration: BoxDecoration(color: Colors.white),
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(
                        width: 1, color: Color.fromRGBO(216, 211, 211, 1)))),
            width: ScreenUtil().setWidth(750),
            height: ScreenUtil().setHeight(80),
            child: Text(
              "订单管理",
              style: TextStyle(color: Color.fromRGBO(90, 90, 90, 1)),
            ),
          ),
          Container(
            height: ScreenUtil().setHeight(160),
            alignment: Alignment.center,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Expanded(
                  child: GestureDetector(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("${goodOrderNum + farmOrders.length + unpayNum}",
                            style: TextStyle(fontSize: 18.0)),
                        Text(
                          '全部订单',
                          style: TextStyle(fontSize: 14.0, color: Colors.grey),
                        )
                      ],
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, "orderManageDetail",
                          arguments: 0);
                    },
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("$unpayNum", style: TextStyle(fontSize: 18.0)),
                        Text(
                          '待付款',
                          style: TextStyle(fontSize: 14.0, color: Colors.grey),
                        )
                      ],
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, "orderManageDetail",
                          arguments: 1);
                    },
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("$goodOrderNum", style: TextStyle(fontSize: 18.0)),
                        Text(
                          '认养订单',
                          style: TextStyle(fontSize: 14.0, color: Colors.grey),
                        )
                      ],
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, "orderManageDetail",
                          arguments: 2);
                    },
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(farmOrders.length.toString(),
                            style: TextStyle(fontSize: 18.0)),
                        Text(
                          '租地订单',
                          style: TextStyle(fontSize: 14.0, color: Colors.grey),
                        )
                      ],
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, "orderManageDetail",
                          arguments: 3);
                    },
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
