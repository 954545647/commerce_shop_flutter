import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:commerce_shop_flutter/components/common/common_title.dart';

class Merchant extends StatefulWidget {
  @override
  _MerchantState createState() => _MerchantState();
}

class _MerchantState extends State<Merchant> {
  var imageList = [
    'assets/images/potatoes1.webp',
    'assets/images/potatoes2.webp',
    'assets/images/potatoes3.webp',
  ];

  @override
  Widget build(BuildContext context) {
    Map args = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      body: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: Container(
          child: ListView(
            children: <Widget>[
              // 标题
              CommonTitle(title: '商户详情'),
              // 商家轮播图
              Stack(
                alignment: Alignment(0, 1.5),
                children: <Widget>[
                  // 商家图片
                  Image.network(
                    args["cover"],
                    height: 200,
                    width: ScreenUtil().setWidth(750),
                    fit: BoxFit.fill,
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
                          child: Image.network(
                            args["cover"],
                            width: ScreenUtil().setWidth(130),
                            height: ScreenUtil().setHeight(130),
                            fit: BoxFit.cover,
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
              // 商家信息
              merchantDetail(args),
            ],
          ),
        ),
      ),
    );
  }

// 商家信息
  Widget merchantDetail(data) {
    return Container(
      margin: EdgeInsets.only(top: 25),
      child: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            child: Text('基本信息'),
          ),
          merchantInfo(data['supplierName'], "0xe60c"),
          merchantInfo(data['phone'], "0xe616"),
          merchantInfo(data['address'], "0xe62f"),
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
