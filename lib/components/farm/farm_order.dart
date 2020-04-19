// 农场订单
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:commerce_shop_flutter/components/common/top_title.dart';
import 'package:commerce_shop_flutter/components/payment/user_adress.dart';
import 'package:provider/provider.dart';
import 'package:commerce_shop_flutter/provider/userData.dart';
import 'package:commerce_shop_flutter/provider/orderData.dart';
import 'package:commerce_shop_flutter/utils/dio.dart';
import 'package:commerce_shop_flutter/components/common/toast.dart';
import "package:commerce_shop_flutter/config/config.dart";

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
    DioUtil.getInstance(context).post("myCoupon").then((val) {
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
  Future newFarmOrder(orderInfos) async {
    final orderdata = Provider.of<OrderData>(context);
    final user = Provider.of<UserData>(context);
    var data = await DioUtil.getInstance(context).post("newFarmOrder", data: {
      "couponId": chooseCoupon["couponId"],
      "orderAmount": orderInfos["total"],
      "payMoney": totalPrice == 0 ? orderInfos["total"] : totalPrice,
      "farmId": orderInfos["farmId"],
      "farmCount": orderInfos["areaNum"],
      "cropsInfos": handleCropInfos(orderInfos["crops"]),
      "address": orderdata.orderInfo.address,
      "orderUsername": user.userInfo.username,
      "supplierId": orderInfos["supplierId"]
    });
    if (data != null && data["code"] == 200) {
      orderId = data["data"]["id"];
      setState(() {});
    } else {
      Toast.toast(context, msg: data["msg"]);
      return;
    }
    // 更新农场信息
    await updateFarmInfo(orderInfos);
    // 修改优惠卷状态
    modifyCouponStatus();
  }

  // 修改用户优惠卷状态
  modifyCouponStatus() {
    DioUtil.getInstance(context).post("handleCoupon", data: {
      "couponId": chooseCoupon["couponId"],
      "orderId": orderId,
    });
  }

  // 更新商品农场（销量，库存）
  Future updateFarmInfo(farmInfo) async {
    DioUtil.getInstance(context)
        .post("updateFarm", data: {"farmInfo": farmInfo}).then((val) {
      if (val != null && val["data"] != null) {
        setState(() {});
      }
    });
  }

  // 处理农场品数据
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
    final orderdata = Provider.of<OrderData>(context);
    final user = Provider.of<UserData>(context);
    int total = orderInfos["total"];
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
                  TopTitle(title: "订单详情", showArrow: true),
                  // 用户地址信息
                  UserAddress(),
                  farmInfo(orderInfos),
                  useCoupon(total, orderInfos),
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
                          if (orderdata.orderInfo.address == "") {
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
                                        onPressed: () async {
                                          await newFarmOrder(orderInfos);
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
            "${Config.apiHost}/${data["imgCover"]}",
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
  Widget useCoupon(total, orderInfos) {
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
    var supplierData = data["Supplier_Info"];
    Map orderInfos = ModalRoute.of(context).settings.arguments;
    int supplierId = orderInfos["supplierId"];
    return GestureDetector(
      onTap: () {
        if (data["threshold"] > total) {
          Toast.toast(context, msg: "订单金额不足");
        }
        if (data["source"] != supplierId) {
          Toast.toast(context, msg: "优惠劵不支持当前商品");
          return;
        }
        chooseCoupon = data;
        totalPrice = total - data["faceValue"];
        setState(() {});
        Navigator.pop(context);
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
              "￥${data["faceValue"]}",
              style: TextStyle(
                  color: Colors.red, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text("满${data["threshold"]}可用"),
            Text(
              data["name"],
            ),
            Text(
                data["type"] == 0 ? "无门槛劵" : "限定商家：${supplierData["username"]}")
          ],
        ),
      ),
    );
  }
}
