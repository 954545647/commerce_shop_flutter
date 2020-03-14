// 商品管理
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:commerce_shop_flutter/utils/dio.dart';
import 'package:provider/provider.dart';
import 'package:commerce_shop_flutter/provider/supplierData.dart';

class GoodManage extends StatefulWidget {
  @override
  _GoodManageState createState() => _GoodManageState();
}

class _GoodManageState extends State<GoodManage> {
  int hasBeenOn = 0; // 已经上架
  int notBeenOn = 0; // 下架
  int goodCount = 0; // 商品数量
  List goodData = [];
  SupplierData supplierData;
  @override
  void initState() {
    super.initState();
    _initSupplierData();
  }

  Future<void> _initSupplierData() async {
    await Future.delayed(Duration(microseconds: 300), () async {
      supplierData = Provider.of<SupplierData>(context);
      await getAllGoods();
    });
  }

  // 获取全部商品
  getAllGoods() {
    DioUtils.getInstance().post("SsupplierGood",
        data: {"id": supplierData.supplierInfo.id}).then((val) {
      if (val != null && val["data"] != null) {
        hasBeenOn = 0;
        notBeenOn = 0;
        goodCount = 0;
        val["data"].forEach((item) {
          if (item["status"] == 0) {
            notBeenOn++;
          } else {
            hasBeenOn++;
          }
          goodCount++;
        });
        goodData = val["data"];
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: ScreenUtil().setWidth(750),
      height: ScreenUtil().setHeight(240),
      decoration: BoxDecoration(color: Colors.white),
      margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
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
              "商品管理",
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
                        Text(hasBeenOn.toString(),
                            style: TextStyle(fontSize: 18.0)),
                        Text(
                          '出售中',
                          style: TextStyle(fontSize: 14.0, color: Colors.grey),
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, "goodManageDetail",
                          arguments: 1);
                    },
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(notBeenOn.toString(),
                            style: TextStyle(fontSize: 18.0)),
                        Text(
                          '已下架',
                          style: TextStyle(fontSize: 14.0, color: Colors.grey),
                        )
                      ],
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, "goodManageDetail",
                          arguments: 0);
                    },
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(goodCount.toString(),
                            style: TextStyle(fontSize: 18.0)),
                        Text(
                          '全部商品',
                          style: TextStyle(fontSize: 14.0, color: Colors.grey),
                        )
                      ],
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, "goodManageDetail",
                              arguments: 2)
                          .then((val) {
                        if (val) {
                          getAllGoods();
                        }
                      });
                    },
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, "publishGood").then((val) {
                        if (val) {
                          getAllGoods();
                        }
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: Color.fromRGBO(243, 248, 254, 1)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.add),
                          Text(
                            '发布新品',
                            style:
                                TextStyle(fontSize: 14.0, color: Colors.grey),
                          )
                        ],
                      ),
                    ),
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
