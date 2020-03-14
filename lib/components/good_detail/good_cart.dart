// 购物车列表
import 'package:flutter/material.dart';
import 'package:commerce_shop_flutter/utils/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:commerce_shop_flutter/components/common/top_title.dart';
import 'package:commerce_shop_flutter/components/common/toast.dart';
import 'package:commerce_shop_flutter/components/common/circleBox.dart';
import 'package:commerce_shop_flutter/components/common/input/my_keyBoard.dart';
import 'package:commerce_shop_flutter/components/common/input/pay_password.dart';
import 'package:provider/provider.dart';
import 'package:commerce_shop_flutter/provider/userData.dart';
import 'package:commerce_shop_flutter/provider/cartData.dart';
import "package:commerce_shop_flutter/config/config.dart";

class MyCart extends StatefulWidget {
  @override
  _MyCartState createState() => _MyCartState();
}

class _MyCartState extends State<MyCart> {
  List userCart = []; // 用户购物车
  List cartState; // 用户购物车状态
  bool totalState;
  int totalPrice = 0;
  List<String> cartCount = []; // 用户购物车的购买数量
  int curItem; // 当前被点击的商品的索引
  @override
  void initState() {
    // 获取购物车信息，并且获取对应商品的商家信息
    initCart();
    super.initState();
  }

  // 初始化购物车
  initCart() {
    DioUtils.getInstance().post("getCarts").then((val) {
      if (val != null && val["data"] != null) {
        userCart = val["data"];
        if (userCart.length != 0) {
          // 创建一个数组，用来关联每一件商品在购物车中的选择状态
          cartState = List<bool>(userCart.length);
          cartState.fillRange(0, userCart.length - 1, false);
          totalState =
              cartState.every((state) => state == true) && cartState.length > 0;
          userCart.forEach((item) {
            cartCount.add(item["count"].toString());
          });
        }
        setState(() {});
      }
    });
  }

// 获取购物车
  getCart() {
    DioUtils.getInstance().post("getCarts").then((val) {
      if (val != null && val["data"] != null) {
        userCart = val["data"];
        userCart.forEach((item) {
          cartCount.add(item["count"].toString());
        });
        // 更新总价
        totalPrice = getTotalPrice();
        setState(() {});
      }
    });
  }

  // 更新购物车
  updateCarts(goodId, count) {
    DioUtils.getInstance().post("updateCarts", data: {
      "goodId": goodId,
      "count": count,
    }).then((val) {
      if (val != null && val["data"] != null) {
        getCart();
      }
    });
  }

  // 提交订单
  submitOrder() {
    List goods = getSelectedGoods();
    // 更新购物车表和订单表
    return goods;
  }

  // 获取被选中的商品
  List getSelectedGoods() {
    final cart = Provider.of<CartData>(context);
    final user = Provider.of<UserData>(context);
    int userId = user.userInfo.id;
    List selectedGoods = [];
    cart.clear(); // 清空Provider中的数据
    for (int i = 0; i < cartState.length; i++) {
      if (cartState[i] == true) {
        var curData = userCart[i];
        // 往Provider中添加当前商品数据
        cart.add(
            userId,
            curData["id"],
            curData["goodId"],
            curData["goodName"],
            curData["supplierId"],
            curData["count"],
            curData["price"],
            curData["expressCost"].toString());
        selectedGoods.add(curData);
      }
    }
    return selectedGoods;
  }

// 是否有选中商品
  bool ifChoose() {
    bool result = false;
    cartState.forEach((item) {
      if (item == true) {
        result = true;
      }
    });
    return result;
  }

  // 获取总价格
  int getTotalPrice() {
    int total = 0;
    // 计算有勾选中的价格
    for (int i = 0; i < userCart.length; i++) {
      if (cartState[i] == true) {
        var good = userCart[i];
        total = total + int.parse(good["price"]) * good["count"];
      }
    }
    return ifChoose() ? total : 0;
  }

// 每个数字的点击事件
  void _onKeyDown(KeyEvent data) {
    String num = cartCount[curItem].toString();
    if (data.isDelete()) {
      if (num.length > 0) {
        cartCount[curItem] = num.substring(0, num.length - 1);
        setState(() {});
      }
    } else if (data.isCommit()) {
      // 点击确认
      onAffirmButton(num);
      Navigator.pop(context);
    } else if (data.isClose()) {
      // 点击关闭
      Navigator.pop(context);
    } else {
      String res = "${cartCount[curItem]}${data.key}";
      cartCount[curItem] = res;
      setState(() {});
    }
  }

  /// 密码键盘 确认按钮 事件
  void onAffirmButton(num) {
    var curGood = userCart[curItem];
    int id = curGood["goodId"];
    int count = int.parse(num);
    // 更新购物车
    updateCarts(id, count);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MediaQuery.removePadding(
          context: context,
          removeTop: true,
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              ListView(
                children: <Widget>[
                  TopTitle(title: "购物车", showArrow: true, ifRefresh: true),
                  cartList(),
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
                    children: <Widget>[
                      CirCleBox(
                        ifCheck: totalState,
                        callback: () {
                          totalState = !totalState;
                          cartState = List<bool>(userCart.length);
                          // 更新购物车的选中状态
                          cartState.fillRange(0, userCart.length, totalState);
                          // 计算商品总价格
                          totalPrice = totalState ? getTotalPrice() : 0;
                          // 更新总价
                          setState(() {});
                        },
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Container(
                        child: Row(
                          children: <Widget>[
                            Text("总计:￥"),
                            Text(totalPrice.toString()),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: ScreenUtil().setWidth(200),
                      ),
                      GestureDetector(
                        onTap: () {
                          bool res = ifChoose();
                          if (userCart.length > 0 && res) {
                            List goods = submitOrder();
                            Navigator.pushNamed(context, "payment",
                                arguments: goods);
                          } else if (!res) {
                            Toast.toast(context, msg: "还没选中任何商品！");
                          } else {
                            Toast.toast(context, msg: "当前购物车为空,赶紧去购物吧");
                          }
                        },
                        child: Container(
                          width: ScreenUtil().setWidth(200),
                          height: 30,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(15)),
                          child: Text(
                            "去结算",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          )),
    );
  }

  // 购物车列表
  Widget cartList() {
    List<Widget> list = [SizedBox(height: 20)];
    if (userCart.length > 0) {
      for (int i = 0; i < userCart.length; i++) {
        list.add(goodInfo(userCart[i], i));
      }
      list.add(SizedBox(height: 50));
      return Column(
        children: list,
      );
    } else {
      return Container(
        height: 300,
        alignment: Alignment.center,
        child: Text(
          "当前购物车为空，赶紧去购物吧！",
          style: TextStyle(fontSize: 20),
        ),
      );
    }
  }

// 购物车单品
  Widget goodInfo(data, index) {
    var curGood = userCart[index]; // 当前商品数据
    String count = cartCount[index]; // 当前商品的数量
    String goodName = data["goodName"];
    String imgCover = data["imgCover"];
    String price = data["price"];
    int stock = data["stock"];
    return Container(
      margin: EdgeInsets.fromLTRB(10, 0, 10, 20),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      height: 150 + MediaQuery.of(context).viewInsets.bottom,
      child: Row(
        children: <Widget>[
          // 商品信息
          SizedBox(width: 20),
          CirCleBox(
            ifCheck: cartState[index],
            callback: () {
              cartState[index] = !cartState[index];
              totalState = cartState.every((state) => state == true);
              if (cartState[index]) {
                totalPrice = totalPrice + int.parse(price) * int.parse(count);
              } else {
                totalPrice = totalPrice - int.parse(price) * int.parse(count);
              }
              setState(() {});
            },
          ),
          SizedBox(width: 20),
          Image.network(
            "${Config.apiHost}$imgCover",
            fit: BoxFit.fill,
            width: 150,
            height: 120,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Text(
                    goodName,
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Text(
                    "${price.toString()}",
                    style: TextStyle(fontSize: 20, color: Colors.red),
                  ),
                ),
                Row(
                  children: <Widget>[
                    SizedBox(width: 20),
                    InkWell(
                      child: Icon(IconData(0xe6e6, fontFamily: 'myIcons'),
                          size: 25),
                      onTap: () {
                        int num = int.parse(count);
                        // 判断库存
                        if (num == 1) {
                          Toast.toast(context, msg: "购买数量最低为1");
                          return;
                        }
                        cartCount[index] =
                            (int.parse(cartCount[index]) - 1).toString();
                        updateCarts(curGood["goodId"], cartCount[index]);
                      },
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          curItem = index;
                        });
                        showModalBottomSheet(
                            backgroundColor: Colors.transparent,
                            isScrollControlled: true,
                            context: context,
                            builder: (context) => new MyKeyboard(
                                  _onKeyDown,
                                ));
                      },
                      child: Container(
                        alignment: Alignment.center,
                        color: Colors.grey,
                        width: 30,
                        child: Text(cartCount[index].toString()),
                      ),
                    ),
                    InkWell(
                      child: Icon(
                        Icons.add,
                        size: 20,
                      ),
                      onTap: () {
                        int num = int.parse(count);
                        if (num == stock) {
                          Toast.toast(context, msg: "库存不足啦");
                          return;
                        }
                        cartCount[index] = (num + 1).toString();
                        updateCarts(curGood["goodId"], cartCount[index]);
                      },
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
