// 优惠卷主页
import 'package:flutter/material.dart';
import 'package:commerce_shop_flutter/utils/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:commerce_shop_flutter/components/common/top_title.dart';

class Coupon extends StatefulWidget {
  @override
  _CouponState createState() => _CouponState();
}

class _CouponState extends State<Coupon> with SingleTickerProviderStateMixin {
  TabController _tabController; //定义一个Controller
  List tabs = ["未使用", "已使用"];
  int count = 1;
  List couponList = [];
  List unUseCoupons = [];
  List useCoupons = [];
  bool hasLoad = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this);
    getCoupon();
  }

  getCoupon() {
    DioUtil.getInstance(context).post("myCoupon").then((val) {
      if (val != null && val["data"] != null) {
        List list = val["data"];
        List useList = [];
        List unUseList = [];
        list.forEach((item) {
          var state = item["use_state"];
          if (state == 1) {
            useList.add(item);
          } else if (state == 0) {
            unUseList.add(item);
          }
        });
        setState(() {
          hasLoad = true;
          couponList = val["data"];
          unUseCoupons = unUseList;
          useCoupons = useList;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            TopTitle(title: "我的优惠卷", showArrow: true),
            Stack(
              children: <Widget>[
                _buildRoot(),
                Positioned(
                    top: 5,
                    right: 5,
                    child: GestureDetector(
                      child: Icon(Icons.more),
                      onTap: () {
                        Navigator.pushNamed(context, "takeCoupon").then((val) {
                          if (val == true) {
                            // 重新刷新页面
                            getCoupon();
                          }
                        });
                      },
                    ))
              ],
            )
          ],
        ),
      )),
    );
  }

  Widget _buildRoot() {
    if (!hasLoad) {
      return Center(child: Text("加载中"));
    } else {
      return Container(
        height: MediaQuery.of(context).size.height - 100,
        child: Column(
          children: <Widget>[
            Container(
              height: 46,
              child: TabBar(
                  // 选中底部的颜色
                  indicatorColor: Colors.grey,
                  unselectedLabelStyle: TextStyle(fontSize: 15),
                  labelStyle: TextStyle(fontSize: 18),
                  isScrollable: true,
                  controller: _tabController,
                  tabs: tabs.map((e) => Tab(text: e)).toList()),
              alignment: Alignment.center,
              color: Colors.white,
            ),
            Expanded(
              flex: 1,
              child: TabBarView(
                children: [unUsed(), alreadyUse()],
                controller: _tabController,
              ),
            )
          ],
        ),
      );
    }
  }

// 未使用
  Widget unUsed() {
    return Container(
      padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
      child: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: unUseCoupons.length,
              itemBuilder: (BuildContext context, int index) {
                return unUsedCoupon(unUseCoupons[index]);
              },
              shrinkWrap: true,
            ),
          )
        ],
      ),
    );
  }

  Widget unUsedCoupon(data) {
    var supplier = data["Supplier_Info"];
    return Container(
      height: 100,
      margin: EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
          border: Border.all(width: 1),
          color: Colors.white,
          borderRadius: BorderRadius.circular(15)),
      child: Row(
        children: <Widget>[
          // 优惠卷金额信息
          Container(
            width: 140,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "￥${data["faceValue"]}",
                  style: TextStyle(
                      // color: Color.fromRGBO(201, 66, 45, 1),
                      color: Colors.red,
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                ),
                Text("满${data["threshold"]}可用",
                    style: TextStyle(
                      // color: Color.fromRGBO(159, 74, 68, 1),
                      color: Colors.red,
                      fontSize: 18,
                    ))
              ],
            ),
          ),
          // 优惠卷使用信息
          Expanded(
            child: Center(
              child: Text(
                  data["type"] == 0 ? "无门槛优惠卷" : "限定商家：${supplier["username"]}",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
            ),
          ),
        ],
      ),
    );
  }

// 已经使用
  Widget alreadyUse() {
    return Container(
      padding: EdgeInsets.fromLTRB(25, 0, 25, 0),
      child: Column(
        children: <Widget>[
          ListView.builder(
            itemCount: useCoupons.length,
            itemBuilder: (BuildContext context, int index) {
              return alreadyUsedCoupon(useCoupons[index]);
            },
            shrinkWrap: true,
          )
        ],
      ),
    );
  }

  Widget alreadyUsedCoupon(data) {
    var supplier = data["Supplier_Info"];
    return Container(
      height: 100,
      margin: EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(15)),
      child: Row(
        children: <Widget>[
          // 优惠卷金额信息
          Container(
            width: 140,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "￥${data["faceValue"]}",
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                ),
                Text("满${data["threshold"]}可用",
                    style: TextStyle(
                      // color: Color.fromRGBO(159, 74, 68, 1),
                      color: Colors.grey,
                      fontSize: 18,
                    ))
              ],
            ),
          ),
          // 优惠卷使用信息
          Center(
            child: Text(
                data["type"] == 0 ? "无门槛优惠卷" : "限定商家：${supplier["username"]}",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey)),
          ),
          Expanded(
            child: Center(
              child: Text(
                "已经使用",
                style: TextStyle(color: Colors.grey),
              ),
            ),
          )
        ],
      ),
    );
  }
}
