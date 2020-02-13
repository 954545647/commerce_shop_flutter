import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:commerce_shop_flutter/components/common/common_title.dart';
import 'package:commerce_shop_flutter/components/common/top_title.dart';
import 'package:commerce_shop_flutter/components/common/good_banner.dart';

class NearFarm extends StatefulWidget {
  @override
  _NearFarmState createState() => _NearFarmState();
}

class _NearFarmState extends State<NearFarm> {
  var imageList = [
    'assets/images/potatoes1.webp',
    'assets/images/potatoes2.webp',
    'assets/images/potatoes3.webp',
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: Container(
          child: ListView(
            children: <Widget>[
              // 标题
              CommonTitle(title: '附近农场'),
              // 商家轮播图
              GoodBanner(
                  imageList: imageList,
                  height: 360,
                  fraction: 0.8,
                  scale: 0.8,
                  topMargin: 10),
              TopTitle(title: '农场列表'),
              // 商家列表
              merchantLists(),
            ],
          ),
        ),
      ),
      // 顶部商品展示
    );
  }

  // 商家列表
  Widget merchantLists() {
    var lists = [
      {
        "imgUrl": "assets/images/potatoes1.webp",
        "name": "智慧农场",
        "location": "重庆市渝中区",
        "phone":'13250504940',
        "nameIcon":"0xe66f",
        "phoneIcon":"0xe616",
        "tabIcon":"0xe60b",
        "shopIcon":"0xe60c",
        "localIcon":"0xe62f"
      },
      {
        "imgUrl": "assets/images/potatoes1.webp",
        "name": "华农农场",
        "location": "广东省广州市",
        "phone":'13250504940',
        "nameIcon":"0xe66f",
        "phoneIcon":"0xe616",
        "tabIcon":"0xe60b",
        "shopIcon":"0xe60c",
        "localIcon":"0xe62f"
      },
      {
        "imgUrl": "assets/images/potatoes1.webp",
        "name": "坦洲农场",
        "location": "中山市坦洲镇",
        "phone":'13250504940',
        "nameIcon":"0xe66f",
        "phoneIcon":"0xe616",
        "tabIcon":"0xe60b",
        "shopIcon":"0xe60c",
        "localIcon":"0xe62f"
      },
    ];
    return Container(
      margin: EdgeInsets.all(15),
      child: Column(
        children: lists.map((item) {
          return merchantDetail(item);
        }).toList(),
      ),
    );
  }

  // 商家详情
  Widget merchantDetail(data) {
    return GestureDetector(
        onTap: () {
          // Navigator.pushNamed(context, 'merchant', arguments: '{"data":"$data"}');
          Navigator.pushNamed(context, 'merchant', arguments: data);
        },
        child: Container(
          height: ScreenUtil().setHeight(240),
          margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black12),
              borderRadius: BorderRadius.circular(20)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Image.asset(
                data['imgUrl'],
                width: ScreenUtil().setWidth(240),
                height: ScreenUtil().setHeight(240),
                fit: BoxFit.fill,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      data['name'],
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    SizedBox(height: 10),
                    Text(
                      data['location'],
                      style: TextStyle(color: Colors.grey),
                    )
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
