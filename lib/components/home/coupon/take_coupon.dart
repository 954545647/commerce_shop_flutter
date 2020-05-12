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
  List couponList = []; // 未拥有的优惠券
  List myCouponId = [];

  @override
  void initState() {
    super.initState();
    getAllCoupon();
  }

// 获取优惠券
  getAllCoupon() async {
    await DioUtil.getInstance(context).post("getAllCoupon").then((val) {
      if (val != null && val["data"] != null) {
        couponList = val["data"];
      }
    });
    setState(() {});
  }

  // 领取优惠券
  takeCoupon(couponData) async {
    var data = await DioUtil.getInstance(context)
        .post("takeCoupon", data: {"couponId": couponData["id"]});
    if (data != null && data["code"] == 200) {
      Toast.toast(context, msg: "领取成功");
    } else {
      Toast.toast(context, msg: "优惠卷已经领取了");
      return;
    }
    // 更新优惠券
    await getAllCoupon();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: Container(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          TopTitle(title: "优惠券中心", showArrow: true, ifRefresh: true),
          _buildRoot(),
        ],
      )),
    ));
  }

  Widget _buildRoot() {
    if (couponList.length > 0) {
      return Container(
          child: Expanded(
        child: ListView.builder(
          itemCount: couponList.length,
          itemBuilder: (BuildContext context, int index) {
            return couponInfo(couponList[index]);
          },
        ),
      ));
    } else {
      return Container(
        height: 500,
        alignment: Alignment.center,
        child: Text("暂时没券，请稍后再来!", style: TextStyle(fontSize: 18)),
      );
    }
  }

// 优惠券信息
  Widget couponInfo(couponData) {
    var supplier = couponData["Supplier_Info"];
    return Container(
      height: 100,
      margin: EdgeInsets.fromLTRB(20, 0, 20, 15),
      padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
      decoration: BoxDecoration(
          border: Border.all(width: 1),
          color: Colors.white,
          borderRadius: BorderRadius.circular(15)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          // 优惠券金额信息
          Container(
            width: 90,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "￥${couponData["faceValue"]}",
                  style: TextStyle(
                      color: Colors.red,
                      fontSize: 23,
                      fontWeight: FontWeight.bold),
                ),
                Text("满${couponData["threshold"]}可用",
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 18,
                    ))
              ],
            ),
          ),
          // 优惠券使用信息
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(couponData["name"],
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                Text(
                    couponData["type"] == 0
                        ? "无门槛优惠券"
                        : "限定商家：${supplier["username"]}",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                Text("剩余数量${couponData["count"]}",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500))
              ],
            ),
          ),
          Container(
              width: 100,
              padding: EdgeInsets.only(right: 5),
              child: FlatButton(
                color: Colors.red,
                highlightColor: Colors.red,
                colorBrightness: Brightness.dark,
                splashColor: Colors.grey,
                child: Text(
                  "立即领取",
                  style: TextStyle(fontSize: 14),
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
                onPressed: () async {
                  await takeCoupon(couponData);
                },
              ))
        ],
      ),
    );
  }
}
