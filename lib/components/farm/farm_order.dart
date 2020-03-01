// 农场订单
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:commerce_shop_flutter/components/common/top_title.dart';
import 'package:commerce_shop_flutter/components/payment/user_adress.dart';
import 'package:provider/provider.dart';
import 'package:commerce_shop_flutter/provider/userData.dart';
import 'package:commerce_shop_flutter/utils/dio.dart';
import 'package:commerce_shop_flutter/components/common/toast.dart';

class FarmOrder extends StatefulWidget {
  @override
  _FarmOrderState createState() => _FarmOrderState();
}

class _FarmOrderState extends State<FarmOrder> {
  List userCouponList = []; // 用户优惠卷列表
  int orderId; // 取消支付加入定时队列的id
  int totalPrice = 0; // 订单总价格
  var chooseCoupon = {}; // 选中的优惠卷
  @override
  void initState() {
    getUserCoupons();
    super.initState();
  }

// 获取用户优惠卷（只获取未使用的）
  getUserCoupons() {
    DioUtils.getInstance().post("myCoupon").then((val) {
      if (val != null && val["data"] != null) {
        userCouponList = [];
        val["data"].forEach((data) {
          if (data["use_state"] == 0) {
            userCouponList.add(data);
          }
        });
        setState(() {});
      }
    });
  }

// 新增农场订单
  newFarmOrder(orderInfos) {
    final user = Provider.of<UserData>(context);
    DioUtils.getInstance().post("newFarmOrder", data: {
      "couponId": chooseCoupon["id"],
      "orderAmount": orderInfos["total"],
      "payMoney": totalPrice == 0 ? orderInfos["total"] : totalPrice,
      "farmId": orderInfos["farmId"],
      "cropsInfos": handleCropInfos(orderInfos["crops"]),
      "address": user.userInfo.address,
      "orderUsername": user.userInfo.username,
    });
  }

  handleCropInfos(data) {
    List orderInfos = [];
    for (var i = 0; i < data.length; i++) {
      orderInfos.add({
        "id": data[i]["id"],
        "imgCover": data[i]["imgCover"],
        "goodName": data[i]["name"],
        "count": data[i]["count"],
        "price": data[i]["price"],
      });
    }
    return orderInfos;
  }

  @override
  Widget build(BuildContext context) {
    Map orderInfos = ModalRoute.of(context).settings.arguments;
    int total = orderInfos["total"];
    final user = Provider.of<UserData>(context);
    var userInfo = user.userInfo;
    return Scaffold(
      body: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: Container(
          color: Color.fromRGBO(242, 242, 242, 1),
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              ListView(
                children: <Widget>[
                  TopTitle(title: "提交订单", showArrow: true),
                  // 用户地址信息
                  UserAddress(),
                  farmInfo(orderInfos),
                  useCoupon(total),
                  SizedBox(
                    height: 60,
                  )
                ],
              ),
              Positioned(
                bottom: 0,
                child: Container(
                  decoration: BoxDecoration(color: Colors.white),
                  height: 60,
                  width: ScreenUtil().setWidth(750),
                  padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      totalPrice == 0 ? Text("总计：$total") : Text("$totalPrice"),
                      SizedBox(
                        width: ScreenUtil().setWidth(180),
                      ),
                      GestureDetector(
                        onTap: () {
                          if (user.userInfo.address == "") {
                            Toast.toast(context, msg: "请选择收获地址");
                            return;
                          }
                          var payMoney = totalPrice == 0
                              ? orderInfos["total"]
                              : totalPrice;
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                    title: Center(child: Text("付款详情")),
                                    content: Container(
                                      height: 50,
                                      child: Column(
                                        children: <Widget>[
                                          Text("付款人：${userInfo.username}"),
                                          Text("付款金额：￥$payMoney")
                                        ],
                                      ),
                                    ),
                                    actions: <Widget>[
                                      new FlatButton(
                                        child: new Text("取消"),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                      new FlatButton(
                                        child: new Text("确定"),
                                        onPressed: () {
                                          newFarmOrder(orderInfos);
                                          Navigator.popAndPushNamed(
                                              context, "index");
                                        },
                                      ),
                                    ],
                                  ));
                        },
                        child: Container(
                          width: ScreenUtil().setWidth(180),
                          height: 30,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(15)),
                          child: Text(
                            "提交订单",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

// 农场信息
  Widget farmInfo(data) {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      height: 200,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: <Widget>[
          Container(
            height: 50,
            alignment: Alignment.center,
            child: Text(
              "农场信息",
              style: TextStyle(fontSize: 20),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(
                data["farmName"],
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(width: 5),
              Text(
                "x${data["areaNum"]}",
                style: TextStyle(fontSize: 16),
              )
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.fromLTRB(0, 0, 0, 5),
            child: cropList(data["crops"]),
          ),
        ],
      ),
    );
  }

  Widget cropList(data) {
    List<Widget> list = [];
    for (var i = 0; i < data.length; i++) {
      var curData = data[i];
      if (curData["count"] > 0) {
        list.add(cropItem(curData));
      }
    }
    return Container(
      height: 100,
      child: ListView(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        children: list,
      ),
    );
  }

  Widget cropItem(data) {
    return Container(
      height: 50,
      width: 100,
      child: Column(
        children: <Widget>[
          Image.network(
            data["imgCover"],
            width: 80,
            height: 50,
            fit: BoxFit.contain,
          ),
          Text(data["name"]),
          Text(data["count"].toString()),
        ],
      ),
    );
  }

// 优惠卷
  Widget useCoupon(total) {
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
                                      fontSize: 25,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              couponList(total)
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

  Widget couponList(total) {
    List<Widget> list = [];
    for (int i = 0; i < userCouponList.length; i++) {
      list.add(couponItem(userCouponList[i], i, total));
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

  Widget couponItem(data, index, total) {
    return GestureDetector(
      onTap: () {
        if (data["with_amount"] > total) {
          Toast.toast(context, msg: "订单金额不足");
        } else {
          chooseCoupon = data;
          totalPrice = total - data["used_amount"];
          setState(() {});
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
              data["name"],
              style: TextStyle(color: Colors.red),
            ),
            Text(data["type"] == 0 ? "无门槛劵" : "促销商品劵")
          ],
        ),
      ),
    );
  }
}
