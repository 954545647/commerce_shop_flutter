// 领劵页面
import 'package:flutter/material.dart';
import 'package:commerce_shop_flutter/utils/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:commerce_shop_flutter/components/common/top_title.dart';
import 'package:commerce_shop_flutter/components/common/toast.dart';

class TakeCoupon extends StatefulWidget {
  @override
  _TakeCouponState createState() => _TakeCouponState();
}

class _TakeCouponState extends State<TakeCoupon> {
  List couponList = [];
  List myCouponId = [];

  @override
  void initState() {
    super.initState();
    getCoupon();
  }

  getCoupon() {
    DioUtils.getInstance().post("myCoupon").then((val) {
      if (val != null && val["data"] != null) {
        var list = [];
        val["data"].forEach((item) {
          list.add(item["couponId"]);
        });
        setState(() {
          myCouponId = list;
        });
      }
    });
    DioUtils.getInstance().post("getAlls").then((val) {
      if (val != null && val["data"] != null) {
        // print("我的优惠卷id$myCouponId");
        var list = [];
        val["data"].forEach((item) {
          // 未领取的优惠卷
          if (myCouponId.indexOf(item["id"]) == -1) {
            list.add(item);
          }
        });
        setState(() {
          couponList = list;
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
          TopTitle(title: "优惠卷中心", showArrow: true, ifRefresh: true),
          _buildRoot(),
        ],
      )),
    ));
  }

  Widget _buildRoot() {
    return Container(
        child: Expanded(
      child: ListView.builder(
        itemCount: couponList.length,
        itemBuilder: (BuildContext context, int index) {
          return couponInfo(couponList[index]);
        },
      ),
    ));
  }

// 优惠卷信息
  Widget couponInfo(data) {
    return Container(
      height: 100,
      margin: EdgeInsets.fromLTRB(15, 0, 15, 15),
      decoration: BoxDecoration(
          border: Border.all(width: 1),
          color: Colors.white,
          borderRadius: BorderRadius.circular(15)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          // 优惠卷金额信息
          Container(
            width: 110,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "￥${data["used_amount"]}",
                  style: TextStyle(
                      // color: Color.fromRGBO(201, 66, 45, 1),
                      color: Colors.red,
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                ),
                Text("满${data["with_amount"]}可用",
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(data["name"]),
                Text(data["type"] == 0 ? "无门槛优惠卷" : "促销商品可用",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500))
              ],
            ),
          ),
          Container(
              width: 120,
              padding: EdgeInsets.only(right: 5),
              child: FlatButton(
                color: Colors.red,
                highlightColor: Colors.red,
                colorBrightness: Brightness.dark,
                splashColor: Colors.grey,
                child: Text("立即领取"),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
                onPressed: () {
                  DioUtils.getInstance().post("handleCoupon",
                      data: {"couponId": data["id"]}).then((val) {
                    if (val != null && val["data"] != null) {
                      getCoupon();
                    }
                    // 已经领取了
                    if (val != null && val["errorCode"] != null) {
                      print(val);
                      var errorCode = val["errorCode"];
                      print(errorCode);
                      if (errorCode != 0) {
                        Toast.toast(context, msg: val["msg"]);
                      }
                    }
                  });
                },
              ))
        ],
      ),
    );
  }
}
