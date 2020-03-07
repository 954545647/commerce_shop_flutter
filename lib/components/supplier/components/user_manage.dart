// 用户中心
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:commerce_shop_flutter/utils/dio.dart';
import "package:commerce_shop_flutter/utils/diaLog.dart";
import 'package:provider/provider.dart';
import 'package:commerce_shop_flutter/provider/supplierData.dart';

class UserManage extends StatefulWidget {
  @override
  _UserManageState createState() => _UserManageState();
}

class _UserManageState extends State<UserManage> {
  @override
  void initState() {
    super.initState();
    getOrders();
  }

  // 获取全部订单
  getOrders() {}

  @override
  Widget build(BuildContext context) {
    final supplier = Provider.of<SupplierData>(context);
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
              "常用模块",
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
                        Text("0", style: TextStyle(fontSize: 18.0)),
                        Text(
                          '个人信息',
                          style: TextStyle(fontSize: 14.0, color: Colors.grey),
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("0", style: TextStyle(fontSize: 18.0)),
                        Text(
                          '消息中心',
                          style: TextStyle(fontSize: 14.0, color: Colors.grey),
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("0", style: TextStyle(fontSize: 18.0)),
                        Text(
                          '修改密码',
                          style: TextStyle(fontSize: 14.0, color: Colors.grey),
                        )
                      ],
                    ),
                    onTap: () {},
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      commonDialog(
                        context: context,
                        title: "确定退出",
                        route: "index",
                        method: () {
                          supplier.logout();
                        },
                      );
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.border_outer),
                        Text(
                          '退出登录',
                          style: TextStyle(fontSize: 14.0, color: Colors.grey),
                        )
                      ],
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