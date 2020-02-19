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

class MyCart extends StatefulWidget {
  @override
  _MyCartState createState() => _MyCartState();
}

class _MyCartState extends State<MyCart> {
  List userCart = []; // 用户购物车
  List cartState; // 用户购物车状态
  List<String> cartCount = []; // 用户购物车的购买数量
  int curItem; // 当前被点击的商品的索引
  @override
  void initState() {
    // 获取购物车信息，并且获取对应商品的商家信息
    getCart();
    super.initState();
  }

  // 获取购物车
  getCart() {
    DioUtils.getInstance().post("getCarts").then((val) {
      if (val != null && val["data"] != null) {
        userCart = val["data"];
        // 创建一个数组，用来关联每一件商品在购物车中的选择状态
        cartState = List<bool>(userCart.length);
        cartState.fillRange(0, userCart.length, true);
        userCart.forEach((item) {
          cartCount.add(item["count"].toString());
        });
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
      onAffirmButton();
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
  void onAffirmButton() {
    var curGood = userCart[curItem];
    int id = curGood["id"];
    int count = int.parse(cartCount[curItem]);
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
                  height: 50,
                  width: ScreenUtil().setWidth(750),
                  color: Colors.white,
                  child: Text("444"),
                ),
              )
            ],
          )),
    );
  }

  // 购物车列表
  Widget cartList() {
    List<Widget> list = [SizedBox(height: 20)];
    for (int i = 0; i < userCart.length; i++) {
      list.add(goodInfo(userCart[i], i));
    }
    list.add(SizedBox(height: 50));
    return Column(
      children: list,
    );
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
              setState(() {});
            },
          ),
          SizedBox(width: 20),
          Image.network(
            imgCover,
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
