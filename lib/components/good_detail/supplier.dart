import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:commerce_shop_flutter/components/common/top_title.dart';
import "package:commerce_shop_flutter/config/config.dart";

class Supplier extends StatefulWidget {
  @override
  _SupplierState createState() => _SupplierState();
}

class _SupplierState extends State<Supplier> {
  @override
  Widget build(BuildContext context) {
    Map args = ModalRoute.of(context).settings.arguments;
    String name = args["username"];
    String phone = args["phone"];
    String imgCover = args["imgCover"];
    return Scaffold(
      body: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: Container(
          child: ListView(
            children: <Widget>[
              // 标题
              TopTitle(title: '商户详情', showArrow: true),
              // 商家封面
              Image.network(
                "${Config.apiHost}$imgCover",
                height: 250,
                fit: BoxFit.cover,
              ),
              // 商家信息
              merchantDetail(imgCover, name, phone),
            ],
          ),
        ),
      ),
    );
  }

  // 商家信息
  Widget merchantDetail(imgCover, name, phone) {
    return Container(
      margin: EdgeInsets.only(top: 25),
      child: Column(
        children: <Widget>[
          merchantInfo(name, "0xe60c"),
          merchantInfo(phone, "0xe616"),
          // merchantInfo(address, "0xe62f"),
        ],
      ),
    );
  }

  // 商家单个字段信息
  Widget merchantInfo(text, icon) {
    var iconName = int.parse(icon);
    return Container(
      height: ScreenUtil().setHeight(100),
      padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey[300]))),
      child: Row(
        children: <Widget>[
          Icon(
            IconData(iconName, fontFamily: 'myIcons'),
            color: Colors.green,
          ),
          SizedBox(width: 20),
          Text(text)
        ],
      ),
    );
  }
}
