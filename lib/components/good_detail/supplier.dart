import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:commerce_shop_flutter/components/common/top_title.dart';

class Supplier extends StatefulWidget {
  @override
  _SupplierState createState() => _SupplierState();
}

class _SupplierState extends State<Supplier> {
  @override
  Widget build(BuildContext context) {
    Map args = ModalRoute.of(context).settings.arguments;
    String name = args["supplierName"];
    String phone = args["phone"];
    String address = args["address"];
    String cover = args["cover"];
    return Scaffold(
      body: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: Container(
          child: ListView(
            children: <Widget>[
              // 标题
              TopTitle(title: '商户详情', showArrow: true),
              // 商家轮播图
              Stack(
                alignment: Alignment(0, 1.5),
                children: <Widget>[
                  Image.network(
                    cover,
                  ),
                  Container(
                    width: ScreenUtil().setWidth(160),
                    height: ScreenUtil().setHeight(160),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Colors.white),
                    child: Stack(
                      alignment: Alignment(0, 0),
                      children: <Widget>[
                        ClipOval(
                          child: Image.asset(
                            'assets/images/potatoes1.webp',
                            width: ScreenUtil().setWidth(130),
                            height: ScreenUtil().setHeight(130),
                            fit: BoxFit.fill,
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
              // 商家信息
              merchantDetail(name, phone, address),
            ],
          ),
        ),
      ),
    );
  }

  // 商家信息
  Widget merchantDetail(name, phone, address) {
    return Container(
      margin: EdgeInsets.only(top: 25),
      child: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            child: Text('基本信息'),
          ),
          merchantInfo(name, "0xe60c"),
          merchantInfo(phone, "0xe616"),
          merchantInfo(address, "0xe62f"),
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
