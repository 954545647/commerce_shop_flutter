// 优惠卷主页
// 修改地址
import 'package:flutter/material.dart';
import 'package:commerce_shop_flutter/utils/dio.dart';
import 'package:flutter/cupertino.dart';
// import 'package:commerce_shop_flutter/components/common/top_title.dart';
// import 'package:commerce_shop_flutter/utils/dio.dart';

class Coupon extends StatefulWidget {
  @override
  _CouponState createState() => _CouponState();
}

class _CouponState extends State<Coupon> with SingleTickerProviderStateMixin {
  TabController _tabController; //定义一个Controller
  List tabs = ["未使用", "已使用"];
  List couponList = [];
  List unUseCoupons = [];
  List useCoupons = [];
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this);
    getCoupon();
  }

  getCoupon() {
    DioUtils.getInstance().post("getAlls").then((val) {
      if (val != null && val["data"] != null) {
        List list = val["data"];
        List useList = [];
        List unUseList = [];
        list.forEach((item) {
          if (item["use_state"] == 0) {
            unUseList.add(item);
          } else {
            useList.add(item);
          }
        });
        print("已经使用$useList,还没使用$unUseList");
        setState(() {
          couponList = val["data"];
          unUseCoupons = unUseList;
          useCoupons = useList;
        });
      }
    });
    print("调用接口");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "我的优惠卷",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        bottom: TabBar(
            //生成Tab菜单
            controller: _tabController,
            tabs: tabs.map((e) => Tab(text: e)).toList()),
      ),
      body: TabBarView(
        controller: _tabController,
        children: tabs.map((e) {
          //创建3个Tab页
          return coupon(e);
        }).toList(),
      ),
    );
  }

  Widget coupon(e) {
    if (e == "未使用") {
      return unUsed();
    } else {
      return alreadyUse();
    }
  }

// 未使用
  Widget unUsed() {
    print(unUseCoupons);
    return Container(
      child: Column(
        children: <Widget>[
          RaisedButton(
            child: Text("去获取更多优惠卷"),
            onPressed: () {
              print(couponList);
            },
          )
        ],
      ),
    );
  }

  Widget alreadyUse() {
    print(useCoupons);
    return Text("已经使用");
  }
}
