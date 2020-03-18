// 商品供应商数据
import 'package:flutter/material.dart';
import 'package:commerce_shop_flutter/utils/dio.dart';
import './payment_item.dart';

class GoodSupplier extends StatefulWidget {
  GoodSupplier({Key key, this.cartInfo, this.goodInfo, this.userId})
      : super(key: key);

  final cartInfo;
  final goodInfo;
  final int userId;

  @override
  _GoodSupplierState createState() => new _GoodSupplierState();
}

class _GoodSupplierState extends State<GoodSupplier> {
  List supplierInfo = []; // 商家信息
  Map<int, List> orderInfo = new Map(); // 商家信息 + 商品信息
  @override
  void initState() {
    super.initState();
    getSupplierData();
  }

  getSupplierData() {
    // 获取购物车中选中的商家id
    var cartData = widget.cartInfo;
    List supplierIds = cartData.getSupplierById(widget.userId);
    // 调用接口，获取商家信息
    DioUtil.getInstance(context).get("SgetAllSuppliers").then((val) {
      if (val != null && val["data"] != null) {
        List suppliers = val["data"]; // 数据库所有商家信息
        // 数据出来，筛选展示的商家信息
        suppliers.forEach((supplierItem) {
          if (supplierIds.indexOf(supplierItem["id"]) != -1) {
            widget.goodInfo.forEach((goodItem) {
              if (goodItem["supplierId"] == supplierItem["id"]) {
                // 先判断当前商品是否已经保存了
                if (orderInfo.containsKey(goodItem["supplierId"])) {
                  // 已经存在了就往原生数组里添加数据
                  var curItem = orderInfo[goodItem["supplierId"]];
                  curItem.add(goodItem);
                } else {
                  orderInfo[goodItem["supplierId"]] = [goodItem];
                }
              }
            });
            supplierInfo.add(supplierItem);
          }
        });
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(),
      margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Column(
        children: <Widget>[allGoods(supplierInfo)],
      ),
    );
  }

// 商家信息 + 商品信息
  Widget allGoods(supplierInfo) {
    List<Widget> list = [];
    for (int i = 0; i < orderInfo.length; i++) {
      list.add(
          allItem(supplierInfo[i], orderInfo[supplierInfo[i]["id"]].toList()));
    }
    return Column(
      children: list,
    );
  }

// 商家信息 + 商品信息
  Widget allItem(supplierData, goodInfo) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(width: 1)),
      child: Column(
        children: <Widget>[
          // 商家信息
          Container(
            height: 50,
            padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Icon(
                  Icons.store,
                  size: 30,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(supplierData["username"])
              ],
            ),
          ),
          // 商品信息
          goodItem(goodInfo)
        ],
      ),
    );
  }

// 商品信息
  Widget goodItem(goodInfo) {
    List<Widget> list = [];
    for (int i = 0; i < goodInfo.length; i++) {
      list.add(OrderItem(goodInfo[i]));
    }
    return Column(
      children: list,
    );
  }
}
