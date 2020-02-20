// 购物车列表
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:commerce_shop_flutter/components/common/top_title.dart';
import './user_adress.dart';
import './good_supplier.dart';
import 'package:commerce_shop_flutter/provider/cartData.dart';
import 'package:provider/provider.dart';
import 'package:commerce_shop_flutter/provider/userData.dart';

class PayMent extends StatefulWidget {
  @override
  _PayMentState createState() => _PayMentState();
}

class _PayMentState extends State<PayMent> {
  @override
  void initState() {
    super.initState();
  }

// 计算总数
  String calTotalPrice(data) {
    int total = 0;
    data.forEach((item) {
      total = total +
          int.parse(item.price) * item.count +
          int.parse(item.expressCost);
    });
    return "$total";
  }

  @override
  Widget build(BuildContext context) {
    List goodLists = ModalRoute.of(context).settings.arguments;
    final cart = Provider.of<CartData>(context);
    final user = Provider.of<UserData>(context);
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
                  UserAdress(),
                  // 订单信息
                  GoodSupplier(
                      cartInfo: cart,
                      userId: user.userInfo.id,
                      goodInfo: goodLists),
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
                            Text("总计：${calTotalPrice(cart.cartInfo)}"),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: ScreenUtil().setWidth(180),
                      ),
                      GestureDetector(
                        onTap: () {},
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
}
