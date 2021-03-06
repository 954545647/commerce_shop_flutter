// 商品详情
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:commerce_shop_flutter/components/common/common_title.dart';
import 'package:commerce_shop_flutter/utils/dio.dart';
import 'package:commerce_shop_flutter/components/common/toast.dart';
import 'package:commerce_shop_flutter/components/good_detail/good_detail.dart';
import 'package:provider/provider.dart';
import 'package:commerce_shop_flutter/provider/userData.dart';
import 'package:commerce_shop_flutter/utils/diaLog.dart';
import "package:commerce_shop_flutter/config/config.dart";
import 'package:flutter/services.dart';

class GoodDetails extends StatefulWidget {
  @override
  _GoodDetailsState createState() => _GoodDetailsState();
}

class _GoodDetailsState extends State<GoodDetails> {
  TextEditingController _numController = TextEditingController();
  UserData userInfo;
  bool ifLogin;
  List userAddress = []; // 用户地址
  List orderCart = []; // 用户购物车
  int goodId; // 商品id;
  var goodInfo = {};
  var supplierInfo = {}; // 商家信息
  int cartNum = 0; // 购物车数量
  int buyCount = 1; // 购物数量
  @override
  void initState() {
    super.initState();
    getCart();
    getGoodInfo();
  }

  // 获取用户购物车
  getCart() async {
    await Future.delayed(Duration(microseconds: 300), () async {
      userInfo = Provider.of<UserData>(context);
      ifLogin = userInfo.isLogin;
      if (ifLogin) {
        DioUtil.getInstance(context).post("getCarts").then((val) {
          if (val != null && val["data"] != null) {
            orderCart = val["data"];
            cartNum = orderCart.length;
            setState(() {});
          }
        });
      }
    });
  }

  // 获取商品信息
  Future<void> getGoodInfo() async {
    await Future.delayed(Duration(microseconds: 300), () async {
      Map argument = ModalRoute.of(context).settings.arguments;
      var data = await DioUtil.getInstance(context)
          .post("getGoodInfo", data: {"id": argument["id"]});
      if (data != null && data["data"] != null) {
        setState(() {
          goodInfo = data["data"];
        });
        // 获取商品商家信息
        await getSupplierInfo();
      }
    });
  }

  // 获取商家信息
  Future<void> getSupplierInfo() async {
    await Future.delayed(Duration(microseconds: 300), () async {
      var data = await DioUtil.getInstance(context)
          .post("SgetSupplierById", data: {"id": goodInfo["supplierId"]});
      if (data != null && data["data"] != null) {
        supplierInfo = data["data"];
        setState(() {});
      }
    });
  }

// 添加到购物车
  addCart(id, goodName, price, buyCount, expressCost) {
    DioUtil.getInstance(context).post("handleCart", data: {
      "goodId": id,
      "goodName": goodName,
      "price": price,
      "count": buyCount,
      "expressCost": expressCost
    }).then((val) {
      if (val != null && val["data"] != null) {
        // 更新购物车
        getCart();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Map argument = ModalRoute.of(context).settings.arguments;
    // 获取路由参数
    if (goodInfo == null) {
      return Text("数据出现异常");
    } else {
      int id = goodInfo["id"];
      String goodName = goodInfo["goodName"];
      String price = goodInfo["price"].toString();
      String expressCost = goodInfo["expressCost"].toString();
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
                  CommonTitle(title: argument["goodName"]),
                  // 商品图片展示
                  goodBanner(argument),
                  // 商品价格、简介、销量
                  goodDetail(goodInfo),
                  // 商品规格（尺码、地址）
                  goodSpecification(argument),
                  // 商品评价
                  // goodEvaluate(argument),
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
                      // 商家详情
                      GestureDetector(
                        onTap: () async {
                          Navigator.pushNamed(context, "supplier",
                              arguments: supplierInfo);
                        },
                        child: Container(
                          width: ScreenUtil().setWidth(100),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[Icon(Icons.shop), Text("商家")],
                          ),
                        ),
                      ),
                      // 购物车
                      GestureDetector(
                        onTap: () {
                          if (!ifLogin) {
                            loginDialog(context, "请先登录");
                          } else {
                            Navigator.pushNamed(context, "myCart").then((val) {
                              if (val) {
                                getCart(); // 更新购物车
                              }
                            });
                          }
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: ScreenUtil().setWidth(100),
                          height: 60,
                          child: Stack(
                            children: <Widget>[
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Icon(Icons.shopping_cart),
                                  Text("购物车"),
                                ],
                              ),
                              ifLogin != null && ifLogin == true && cartNum > 0
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
                                      right: 0,
                                      top: 4,
                                    )
                                  : Container(height: 0.0, width: 0.0)
                            ],
                          ),
                        ),
                      ),
                      // 加入购物车
                      GestureDetector(
                        onTap: () {
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
                      // 联系商家
                      GestureDetector(
                        onTap: () {
                          // 联系商家
                          if (!ifLogin) {
                            loginDialog(context, "请先登录");
                            return;
                          } else {
                            Navigator.pushNamed(context, "chatToSupplier",
                                arguments: supplierInfo);
                          }
                        },
                        child: Container(
                          height: 30,
                          width: ScreenUtil().setWidth(200),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Color.fromRGBO(255, 174, 28, 1),
                              borderRadius: BorderRadius.circular(15)),
                          child: Text(
                            "联系商家",
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
      );
    }
  }

//  商品图片展示
  Widget goodBanner(argument) {
    return Image.network(
      "${Config.apiHost}/${argument["imgCover"]}",
      height: 300,
      fit: BoxFit.fill,
    );
  }

// 商品规格（尺码+地址）
  Widget goodSpecification(argument) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 15, 0, 15),
      height: ScreenUtil().setHeight(120),
      width: ScreenUtil().setWidth(750),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15), color: Colors.white),
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
        if (argument["stock"] == 0) {
          Toast.toast(context, msg: "商品没库存啦~");
          return;
        }
        showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          builder: (context) => Container(
            height: MediaQuery.of(context).viewInsets.bottom + 330,
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
                        "${Config.apiHost}/${argument["imgCover"]}",
                        fit: BoxFit.cover,
                        width: 150,
                        height: 150,
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Column(
                        children: <Widget>[
                          Text("￥${argument['price']}"),
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
                        child: Icon(
                          IconData(0xe6e6, fontFamily: "myIcons"),
                          size: 30,
                        ),
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
                        child: TextField(
                          controller: _numController,
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
                          inputFormatters: [
                            // 长度限制
                            LengthLimitingTextInputFormatter(50),
                            WhitelistingTextInputFormatter.digitsOnly
                          ],
                          keyboardType: TextInputType.phone,
                          style: TextStyle(fontSize: 16.0, color: Colors.black),
                          decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: 16.0),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.black54,
                                      style: BorderStyle.solid)), //获取焦点时，下划线的样式
                              hintText: "购买数量"),
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
                    if (_numController.text == "" ||
                        _numController.text == "0") {
                      Toast.toast(context, msg: "数量最低为1");
                      _numController.text = "1";
                      return;
                    }
                    int num = int.parse(_numController.text);
                    int max = argument["stock"];
                    if (num > max) {
                      Toast.toast(context, msg: "库存不足,最多为$max");
                      _numController.text = "$max";
                      return;
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
                  Text("$buyCount")
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
