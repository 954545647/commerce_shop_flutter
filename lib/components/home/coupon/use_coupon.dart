import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:commerce_shop_flutter/components/common/toast.dart';

// 优惠卷
// userCouponList 保存用户优惠卷的数组
// couponInfo当前优惠卷的信息
// totalPrice 订单总价格
// chooseCoupon 选中的优惠卷
// getUserCoupons 获取用户优惠卷的方法
// setState 重绘
Widget useCoupon(
    {context,
    chooseCoupon,
    userCouponList,
    totalPrice,
    getUserCoupons,
    setState}) {
  return Container(
    margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
    padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15), color: Colors.white),
    height: 60,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text("选择优惠卷"),
        Text(
          chooseCoupon.containsKey("name") ? chooseCoupon["name"] : "",
          style: TextStyle(color: Colors.red, fontSize: 18),
        ),
        InkWell(
          child: Icon(Icons.more_horiz),
          onTap: () {
            showModalBottomSheet(
                context: context,
                builder: (context) => Container(
                    color: Colors.white,
                    height: 300,
                    child: Stack(
                      children: <Widget>[
                        ListView(
                          children: <Widget>[
                            Container(
                              alignment: Alignment.center,
                              height: 80,
                              child: Text(
                                "优惠卷列表",
                                style: TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.w600),
                              ),
                            ),
                            couponList(
                                context: context,
                                userCouponList: userCouponList,
                                getUserCoupons: getUserCoupons,
                                totalPrice: totalPrice,
                                chooseCoupon: chooseCoupon,
                                setState: setState)
                          ],
                        ),
                        Positioned(
                          right: 20,
                          top: 30,
                          child: InkWell(
                            onTap: () {
                              // 前往领劵
                              Navigator.popAndPushNamed(context, "takeCoupon")
                                  .then((val) {
                                if (val) {
                                  getUserCoupons();
                                }
                              });
                            },
                            child: Icon(Icons.more_horiz),
                          ),
                        )
                      ],
                    )));
          },
        ),
      ],
    ),
  );
}

Widget couponList(
    {context,
    userCouponList,
    getUserCoupons,
    totalPrice,
    chooseCoupon,
    setState}) {
  List<Widget> list = [];
  for (int i = 0; i < userCouponList.length; i++) {
    list.add(couponItem(
        context: context,
        couponInfo: userCouponList[i],
        totalPrice: totalPrice,
        chooseCoupon: chooseCoupon,
        setState: setState));
  }
  if (list.length > 0) {
    return Column(children: list);
  } else {
    return GestureDetector(
      onTap: () {
        // 前往领劵
        Navigator.popAndPushNamed(context, "takeCoupon").then((val) {
          if (val) {
            getUserCoupons();
          }
        });
      },
      child: Container(
        alignment: Alignment.center,
        height: 50,
        child: Text(
          "点击前往领劵",
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}

Widget couponItem({context, couponInfo, totalPrice, chooseCoupon, setState}) {
  return GestureDetector(
    onTap: () {
      if (couponInfo["threshold"] > totalPrice) {
        Toast.toast(context, msg: "订单金额不足");
      } else {
        chooseCoupon = couponInfo;
        setState();
        Navigator.pop(context);
      }
    },
    child: Container(
      alignment: Alignment.center,
      width: ScreenUtil().setWidth(750),
      margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
      height: 60,
      decoration: BoxDecoration(
          border: Border.all(width: 1),
          borderRadius: BorderRadius.circular(15)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Text(
            couponInfo["name"],
            style: TextStyle(color: Colors.red),
          ),
          Text(couponInfo["type"] == 0 ? "无门槛劵" : "促销商品劵")
        ],
      ),
    ),
  );
}
