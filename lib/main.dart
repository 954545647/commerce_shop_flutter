import 'package:flutter/material.dart';
import 'package:commerce_shop_flutter/pages/home.dart';
import 'package:commerce_shop_flutter/pages/market.dart';
import 'package:commerce_shop_flutter/pages/user_center.dart';
import 'package:commerce_shop_flutter/pages/rent_land.dart';
import 'package:commerce_shop_flutter/pages/welcome.dart';
import 'package:commerce_shop_flutter/pages/index.dart';
import 'package:commerce_shop_flutter/components/home/good_detail/index.dart';
import 'package:commerce_shop_flutter/components/home/sign_in/index.dart';
import 'package:commerce_shop_flutter/components/home/sign_in/integral_mall.dart';
import 'package:commerce_shop_flutter/components/home/near_farm/index.dart';
import 'package:commerce_shop_flutter/components/home/near_farm/merchant_detail.dart';
import 'package:commerce_shop_flutter/components/welcome/Login.dart';
import 'package:commerce_shop_flutter/components/welcome/Register.dart';
import 'package:commerce_shop_flutter/components/welcome/Forget.dart';
import 'package:commerce_shop_flutter/components/user_center/SetUp.dart';
import 'package:provider/provider.dart';
import 'package:commerce_shop_flutter/provider/userData.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider.value(value: UserData()),
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
        ),
        routes: {
          'welcome': (context) => Welcome(),
          'index': (context) => IndexPage(),
          'home': (context) => Home(),
          'login': (context) => Login(),
          'forget': (context) => Forget(),
          'register': (context) => Register(),
          'setup': (context) => SetUp(),
          'market': (context, {arguments}) => Market(),
          'userCenter': (context, {arguments}) => UserCenter(),
          'rentLand': (context, {arguments}) => RentLand(),
          'homeGoodsDetail': (context, {arguments}) => GoodDetails(),
          'signIn': (context, {arguments}) => SignIn(),
          'integralMall': (context, {arguments}) => IntegralMall(),
          'nearFarm': (context, {arguments}) => NearFarm(),
          'merchant': (context, {arguments}) => Merchant(),
        },
        // initialRoute: '/welcome',
        home: Register());
  }
}
