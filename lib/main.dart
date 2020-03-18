import 'package:flutter/material.dart';
import 'package:commerce_shop_flutter/pages/welcome.dart';
import "package:commerce_shop_flutter/config/config.dart";
import 'package:provider/provider.dart';
import 'package:commerce_shop_flutter/provider/userData.dart';
import 'package:commerce_shop_flutter/provider/supplierData.dart';
import 'package:commerce_shop_flutter/provider/socketData.dart';
import 'package:commerce_shop_flutter/provider/orderData.dart';
import 'package:commerce_shop_flutter/provider/cartData.dart';
import "package:commerce_shop_flutter/config/router.dart";

void main() {
  Config.env = Env.DEV; //设定运行环境的环境变量
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider.value(value: UserData()), // 用户数据
      ChangeNotifierProvider.value(value: CartData()), // 购物车数据
      ChangeNotifierProvider.value(value: OrderData()), // 订单数据
      ChangeNotifierProvider.value(value: SupplierData()), // 商家数据
      ChangeNotifierProvider.value(value: SocketData()), // 商家数据
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  MyApp({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: '认养农场',
        debugShowCheckedModeBanner: false, // 关闭debug显示条
        theme: ThemeData(
            primaryColor: Colors.lightGreen,
            accentColor: Color.fromRGBO(98, 148, 208, 1)),
        routes: routes,
        home: Welcome());
  }
}
