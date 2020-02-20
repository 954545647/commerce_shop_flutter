// 商品详情
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:commerce_shop_flutter/components/common/common_title.dart';
import 'dart:convert';
import 'package:commerce_shop_flutter/utils/dio.dart';
import 'package:commerce_shop_flutter/components/common/toast.dart';
import 'package:commerce_shop_flutter/components/good_detail/good_detail.dart';
import 'package:commerce_shop_flutter/components/good_detail/good_comment.dart';
import 'package:provider/provider.dart';
import 'package:commerce_shop_flutter/provider/userData.dart';
import 'package:commerce_shop_flutter/utils/diaLog.dart';

class GoodDetails extends StatefulWidget {
  @override
  _GoodDetailsState createState() => _GoodDetailsState();
}

class _GoodDetailsState extends State<GoodDetails> {
  TextEditingController _numController = TextEditingController();
  List userAddress = []; // 用户地址
  List orderCart = []; // 用户购物车
  int cartNum = 0; // 购物车数量
  int buyCount = 1; // 购物数量
  @override
  void initState() {
    super.initState();
    // getAddress();
    getCart();
  }

// // 获取地址
//   getAddress() {
//     DioUtils.getInstance().get("address").then((val) {
//       if (val != null && val["data"] != null) {
//         setState(() {
//           userAddress = val["data"];
//         });
//       }
//     });
//   }

  // 获取购物车
  getCart() {
    DioUtils.getInstance().post("getCarts").then((val) {
      if (val != null && val["data"] != null) {
        orderCart = val["data"];
        cartNum = orderCart.length;
        setState(() {});
      }
    });
  }

// 添加到购物车
  addCart(id, goodName, price, buyCount, expressCost) {
    DioUtils.getInstance().post("handleCart", data: {
      "goodId": id,
      "goodName": goodName,
      "price": price,
      "count": buyCount,
      "expressCount": expressCost
    }).then((val) {
      if (val != null && val["data"] != null) {
        getCart();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final userInfo = Provider.of<UserData>(context);
    bool ifLogin = userInfo.isLogin; // 用户是否登录
    // 获取路由参数
    var args = ModalRoute.of(context).settings.arguments;
    Map<String, dynamic> argument = json.decode(args);
    var id = argument["id"];
    var goodName = argument["name"];
    var price = argument["price"].toString();
    var expressCost = argument["expressCost"].toString();
    return Scaffold(
      body: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            // 商品标题
            ListView(
              children: <Widget>[
                CommonTitle(title: argument['name'].toString()),
                // 商品图片展示
                goodBanner(argument),
                // 商品价格、简介、销量
                goodDetail(argument),
                // 商品规格（尺码、地址）
                goodSpecification(argument),
                goodEvaluate(argument),
              ],
            ),
            Positioned(
              bottom: 0,
              child: Container(
                width: ScreenUtil().setWidth(750),
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(width: 1, color: Colors.grey)),
                    color: Colors.white),
                height: 60,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        //
                      },
                      child: Container(
                        width: ScreenUtil().setWidth(100),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[Icon(Icons.shop), Text("商家")],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (!ifLogin) {
                          loginDialog(context, "请先登录");
                        } else {
                          Navigator.pushNamed(context, "myCart");
                        }
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: ScreenUtil().setWidth(100),
                        height: 60,
                        child: Stack(
                          children: <Widget>[
                            Positioned(
                              child: Icon(Icons.shopping_cart),
                              left: 5,
                              top: 8,
                            ),
                            Positioned(
                              child: Text("购物车"),
                              top: 32,
                            ),
                            ifLogin
                                ? Positioned(
                                    child: Container(
                                      width: 18,
                                      height: 18,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                              width: 1, color: Colors.red)),
                                      child: Center(
                                        child: Text(
                                          cartNum.toString(),
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ),
                                    ),
                                    right: 14,
                                    top: 4,
                                  )
                                : Container()
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // 将当前商品及数量加入购物车
                        if (!ifLogin) {
                          loginDialog(context, "请先登录");
                        } else {
                          addCart(id, goodName, price, buyCount, expressCost);
                        }
                      },
                      child: Container(
                        height: 30,
                        width: ScreenUtil().setWidth(200),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(15)),
                        child: Text(
                          "加入购物车",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    Container(
                      height: 30,
                      width: ScreenUtil().setWidth(200),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Color.fromRGBO(255, 174, 28, 1),
                          borderRadius: BorderRadius.circular(15)),
                      child: Text(
                        "立即支付",
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
      // 顶部商品展示
    );
  }

//  商品图片展示
  Widget goodBanner(argument) {
    return Image.network(argument["imgCover"]);
  }

// 商品规格（尺码+地址）
  Widget goodSpecification(argument) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 15, 0, 15),
      height: ScreenUtil().setHeight(120),
      width: ScreenUtil().setWidth(750),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15), color: Colors.white),
      // color: Colors.white,
      child: Container(
          child: Column(
        children: <Widget>[
          specification(argument),
          // location(argument)
        ],
      )),
    );
  }

// 选择尺码
  Widget specification(argument) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (context) => Container(
            height: 330 + MediaQuery.of(context).viewInsets.bottom,
            padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              children: <Widget>[
                // 商品图片和价格信息
                Container(
                  child: Row(
                    children: <Widget>[
                      Image.network(
                        argument["imgCover"],
                        fit: BoxFit.cover,
                        width: 150,
                        height: 150,
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Column(
                        children: <Widget>[
                          Text("￥${argument['price'].toString()}"),
                          Text("库存：${argument["stock"]}")
                        ],
                      )
                    ],
                  ),
                ),
                // 购买数量
                Container(
                  height: 100,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text("购买数量："),
                      InkWell(
                        child: Icon(Icons.ac_unit),
                        onTap: () {
                          if (_numController.text == "") {
                            _numController.text = "0";
                          }
                          if (_numController.text == "0") {
                            Toast.toast(context, msg: "购买数量最低为0");
                          } else {
                            _numController.text =
                                "${int.parse(_numController.text) - 1}";
                          }
                        },
                      ),
                      Container(
                        width: 200,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            TextField(
                              controller: _numController,
                              keyboardType: TextInputType.number,
                              onChanged: (v) {
                                int num = int.parse(v);
                                int max = int.parse(argument["stock"]);
                                if (num > max) {
                                  Toast.toast(context, msg: "库存不足啦");
                                  _numController.text = "$max";
                                }
                                if (num < 0) {
                                  Toast.toast(context, msg: "购买数量不能低于0");
                                  _numController.text = "0";
                                }
                              },
                              decoration: InputDecoration(
                                  labelText: "购买数量",
                                  prefixIcon: Icon(Icons.person)),
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        child: Icon(Icons.add),
                        onTap: () {
                          if (_numController.text == "") {
                            _numController.text = "1";
                          }
                          if (_numController.text == argument["stock"]) {
                            Toast.toast(context, msg: "库存不足啦");
                          } else {
                            _numController.text =
                                "${int.parse(_numController.text) + 1}";
                          }
                        },
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  child: Container(
                    height: 50,
                    margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                    width: ScreenUtil().setWidth(280),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(255, 174, 28, 1),
                        borderRadius: BorderRadius.circular(15)),
                    child: Text(
                      "确认",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  onTap: () {
                    if (_numController.text == "") {
                      Toast.toast(context, msg: "数量最低为1");
                    }
                    setState(() {
                      buyCount = int.parse(_numController.text);
                    });
                    Navigator.pop(context);
                  },
                )
              ],
            ),
          ),
        );
      },
      child: Container(
        height: ScreenUtil().setHeight(120),
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
                    width: 1, color: Color.fromRGBO(242, 242, 242, 1)))),
        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text('选择', style: TextStyle(color: Colors.grey)),
                  SizedBox(width: 25),
                  Text('数量', style: TextStyle(color: Colors.black)),
                  SizedBox(
                    width: 10,
                  ),
                  Text(buyCount.toString())
                ],
              ),
              InkWell(
                child: Icon(Icons.arrow_right),
              )
            ]),
      ),
    );
  }

// 选择地址
  // Widget location(argument) {
  //   return GestureDetector(
  //     onTap: () {},
  //     child: Container(
  //       height: ScreenUtil().setHeight(140),
  //       decoration: BoxDecoration(
  //           border: Border(
  //               bottom: BorderSide(
  //                   width: 1, color: Color.fromRGBO(242, 242, 242, 1)))),
  //       padding: EdgeInsets.fromLTRB(10, 15, 10, 0),
  //       child: Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: <Widget>[
  //             Row(
  //               children: <Widget>[
  //                 Container(
  //                   height: ScreenUtil().setHeight(150),
  //                   child: Text('送至', style: TextStyle(color: Colors.grey)),
  //                 ),
  //                 SizedBox(width: 25),
  //                 Container(
  //                   alignment: Alignment.topCenter,
  //                   margin: EdgeInsets.only(right: 10),
  //                   height: ScreenUtil().setHeight(150),
  //                   child: Icon(IconData(0xe62f, fontFamily: 'myIcons')),
  //                 ),
  //                 Container(
  //                     height: ScreenUtil().setHeight(150),
  //                     width: ScreenUtil().setWidth(500),
  //                     child: Text(userAddress[0]["address"],
  //                         maxLines: 2, overflow: TextOverflow.ellipsis))
  //               ],
  //             ),
  //           ]),
  //     ),
  //   );
  // }
}
