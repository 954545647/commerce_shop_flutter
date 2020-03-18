// 订单主页
import 'package:flutter/material.dart';
import 'package:commerce_shop_flutter/utils/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:commerce_shop_flutter/components/common/top_title.dart';
// import 'package:commerce_shop_flutter/utils/utils.dart';
import "package:commerce_shop_flutter/config/config.dart";
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:commerce_shop_flutter/provider/supplierData.dart';

class GoodManageDetail extends StatefulWidget {
  @override
  _GoodManageDetailState createState() => _GoodManageDetailState();
}

class _GoodManageDetailState extends State<GoodManageDetail> {
  List goodData = [];
  SupplierData supplierData;
  @override
  void initState() {
    super.initState();
    _initSupplierData();
  }

  // 初始化商家数据
  Future<void> _initSupplierData() async {
    await Future.delayed(Duration(microseconds: 300), () async {
      supplierData = Provider.of<SupplierData>(context);
      await getAllGoods();
    });
  }

  // 改变商品状态
  Future<void> changeState(data) async {
    int status = data["status"] == 0 ? 1 : 0;
    await DioUtil.getInstance(context).post("updateGoodStatus",
        data: {"goodId": data["id"], "status": status});
    await getAllGoods();
  }

  // 获取全部商品
  getAllGoods() {
    int status = ModalRoute.of(context).settings.arguments;
    DioUtil.getInstance(context).post("SsupplierGood",
        data: {"id": supplierData.supplierInfo.id}).then((val) {
      if (val != null && val["data"] != null) {
        if (status == 2) {
          goodData = val["data"];
        } else {
          val["data"].forEach((item) {
            if (item["status"] == status) {
              goodData.add(item);
            }
          });
        }
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
            TopTitle(
              title: "详情",
              showArrow: true,
              ifRefresh: true,
            ),
            goodLists(goodData)
          ],
        ),
      ),
    ));
  }

  Widget goodLists(orderList) {
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
        child: Text("暂无商品"),
      );
    }
  }

  Widget orderItem(data) {
    int ifShow = ModalRoute.of(context).settings.arguments;
    String name = data['goodName'];
    String price = data['price'];
    String desc = data['descript'];
    String imgCover = data['imgCover'];
    int status = data["status"];
    return Container(
      height: ScreenUtil().setHeight(340),
      decoration: BoxDecoration(
          color: status == 1 ? Colors.white : Colors.black38,
          border: Border(
              bottom: BorderSide(color: Color.fromRGBO(242, 242, 242, 1)))),
      padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
      child: Row(
        children: <Widget>[
          Image.network("${Config.apiHost}/$imgCover",
              width: ScreenUtil().setWidth(300),
              height: ScreenUtil().setHeight(300),
              fit: BoxFit.cover),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                // 描述
                Text(
                  desc.toString(),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 20),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    // 商品名字
                    Text(
                      name.toString(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 20),
                    ),
                    // 商品价格
                    Text("￥$price",
                        style: TextStyle(
                            // color: Color.fromRGBO(201, 66, 45, 1),
                            color: Colors.red,
                            fontSize: 25,
                            fontWeight: FontWeight.bold)),
                  ],
                )
              ],
            ),
          ),
          ifShow == 2
              ? Container(
                  width: ScreenUtil().setWidth(120),
                  child: RaisedButton(
                    child: status == 1 ? Text("下架") : Text("上架"),
                    onPressed: () {
                      // 修改状态
                      changeState(
                        data,
                      );
                    },
                  ),
                )
              : Container(
                  width: 0,
                  height: 0,
                )
        ],
      ),
    );
  }
}
