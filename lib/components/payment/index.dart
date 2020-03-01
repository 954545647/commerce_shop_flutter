// 订单页面
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:commerce_shop_flutter/components/common/top_title.dart';
import './user_adress.dart';
import './good_supplier.dart';
import 'package:commerce_shop_flutter/provider/cartData.dart';
import 'package:provider/provider.dart';
import 'package:commerce_shop_flutter/provider/userData.dart';
import 'package:commerce_shop_flutter/utils/dio.dart';
import 'package:commerce_shop_flutter/components/common/toast.dart';

class PayMent extends StatefulWidget {
  @override
  _PayMentState createState() => _PayMentState();
}

class _PayMentState extends State<PayMent> {
  List userCouponList = []; // 用户优惠卷列表
  int orderId; // 取消支付加入定时队列的id
  String totalPrice; // 订单总价格
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

// 更新商品信息（销量，库存）
  updateGoodInfo(goodInfo) {
    DioUtils.getInstance()
        .post("updateGood", data: {"goodInfo": goodInfo}).then((val) {
      if (val != null && val["data"] != null) {
        setState(() {});
      }
    });
  }

  // 修改用户优惠卷状态
  modifyCouponStatus() {
    DioUtils.getInstance().post("handleCoupon",
        data: {"couponId": chooseCoupon["id"], "orderId": orderId}).then((val) {
      if (val != null && val["data"] != null) {
        setState(() {});
      }
    });
  }

// 修改用户的积分
  modifyUserPoint() {
    DioUtils.getInstance().post("changeIntegral", data: {"source": 2});
  }

// 计算总数
  String calTotalPrice(data, {cut = 0}) {
    int total = 0;
    data.forEach((item) {
      total = total +
          int.parse(item.price) * item.count +
          int.parse(item.expressCost);
    });
    if (cut == null) cut = 0;
    total -= cut;
    totalPrice = "$total";
    setState(() {});
    return totalPrice;
  }

// 处理订单数据
  List handleOrderData(goodLists, type) {
    List data = [];
    for (int i = 0; i < goodLists.length; i++) {
      data.add(goodLists[i]["$type"]);
    }
    return data;
  }

// 处理更新商品所需信息
  List handleUpdateGoodInfo(goodLists) {
    List list = [];
    for (var i = 0; i < goodLists.length; i++) {
      var cur = goodLists[i];
      list.add({"goodId": cur["goodId"], "count": cur["count"]});
    }
    return list;
  }

// 获取供应商id
  List getSuppliersId(cartInfo, userId) {
    List supplierIds = cartInfo.getSupplierById(userId); // 供应商id
    return supplierIds;
  }

// 提交订单
  submitOrder(
      {couponId,
      orderAmount,
      payMoney,
      address,
      goodsId,
      orderUsername,
      status}) async {
    // final user = Provider.of<UserData>(context);
    await DioUtils.getInstance().post('newOrder', data: {
      "couponId": couponId,
      "orderAmount": orderAmount,
      "payMoney": payMoney,
      "address": address,
      "goodsId": goodsId,
      "orderUsername": orderUsername,
      "status": status
    }).then((val) {
      if (val != null && val["data"] != null) {
        orderId = val["data"]["id"];
        // if (val["data"]["status"] == 1) {
        //   user.addUnpayOrder(user.userInfo.id, orderId);
        // }
        setState(() {});
      }
    });
    // 更新购物车
    await updateCarts();
  }

  // 更新购物车
  updateCarts() async {
    final cart = Provider.of<CartData>(context);
    List cartIds = [];
    cart.cartInfo.forEach((item) {
      cartIds.add(item.cartId);
    });
    await DioUtils.getInstance().post('deleteCart', data: {"cartIds": cartIds});
  }

  // 开启定时任务
  startTask() {
    print(orderId);
    DioUtils.getInstance().post('startTask', data: {"orderId": orderId});
  }

  @override
  Widget build(BuildContext context) {
    List goodLists = ModalRoute.of(context).settings.arguments;
    final cart = Provider.of<CartData>(context);
    final user = Provider.of<UserData>(context);
    List goodsId = handleOrderData(goodLists, "goodId");
    List goodInfo = handleUpdateGoodInfo(goodLists);
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
                  // 订单信息
                  GoodSupplier(
                      cartInfo: cart,
                      userId: user.userInfo.id,
                      goodInfo: goodLists),
                  useCoupon(),
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
                      Container(
                        child: Row(
                          children: <Widget>[
                            Text(
                                "总计：${calTotalPrice(cart.cartInfo, cut: chooseCoupon["used_amount"])}"),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: ScreenUtil().setWidth(180),
                      ),
                      GestureDetector(
                        onTap: () {
                          if (user.userInfo.address == "") {
                            Toast.toast(context, msg: "请选择收获地址");
                            return;
                          }
                          var userInfo = user.userInfo;
                          int cut = chooseCoupon["used_amount"] != null
                              ? chooseCoupon["used_amount"]
                              : 0;
                          var couponId = chooseCoupon["id"] != null
                              ? chooseCoupon["id"]
                              : null;
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                    title: Center(child: Text("付款详情")),
                                    content: Container(
                                      height: 50,
                                      child: Column(
                                        children: <Widget>[
                                          Text("付款人：${userInfo.username}"),
                                          Text("付款金额：￥$totalPrice")
                                        ],
                                      ),
                                    ),
                                    actions: <Widget>[
                                      new FlatButton(
                                        child: new Text("取消"),
                                        onPressed: () async {
                                          await submitOrder(
                                            couponId: couponId,
                                            orderAmount:
                                                int.parse(totalPrice) + cut,
                                            payMoney: int.parse(totalPrice),
                                            address: user.userInfo.address,
                                            goodsId: goodsId,
                                            orderUsername: userInfo.username,
                                            status: 1,
                                          );
                                          // 修改商品信息
                                          updateGoodInfo(goodInfo);
                                          // 修改优惠卷状态
                                          modifyCouponStatus();
                                          // 开启定时器
                                          startTask();
                                          Navigator.of(context)
                                              .pushNamedAndRemoveUntil(
                                                  'unpayOrder',
                                                  ModalRoute.withName('index'));
                                        },
                                      ),
                                      new FlatButton(
                                        child: new Text("确定"),
                                        onPressed: () async {
                                          await submitOrder(
                                            couponId: couponId,
                                            orderAmount:
                                                int.parse(totalPrice) + cut,
                                            payMoney: int.parse(totalPrice),
                                            address: user.userInfo.address,
                                            goodsId: goodsId,
                                            orderUsername: userInfo.username,
                                            status: 2,
                                          );
                                          updateGoodInfo(goodInfo);
                                          // 修改优惠卷状态
                                          modifyCouponStatus();
                                          modifyUserPoint();
                                          // 路由回退到购物车页面
                                          Navigator.of(context)
                                              .pushNamedAndRemoveUntil(
                                                  'allOrder',
                                                  ModalRoute.withName('index'));
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

// 优惠卷
  Widget useCoupon() {
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
                              couponList()
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

  Widget couponList() {
    List<Widget> list = [];
    for (int i = 0; i < userCouponList.length; i++) {
      list.add(couponItem(userCouponList[i], i));
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

  Widget couponItem(data, index) {
    return GestureDetector(
      onTap: () {
        if (data["with_amount"] > int.parse(totalPrice)) {
          Toast.toast(context, msg: "订单金额不足");
        } else {
          chooseCoupon = data;
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
