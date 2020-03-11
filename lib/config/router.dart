import 'package:commerce_shop_flutter/pages/welcome.dart';
import 'package:commerce_shop_flutter/pages/index.dart';
import 'package:commerce_shop_flutter/components/good_detail/index.dart';
import 'package:commerce_shop_flutter/components/home/news/hot_news.dart';
import 'package:commerce_shop_flutter/components/home/news/news_detail.dart';
import 'package:commerce_shop_flutter/components/home/monitor/monitor.dart';
import 'package:commerce_shop_flutter/components/sign_in/index.dart';
import 'package:commerce_shop_flutter/components/integral_shop/index.dart';
import 'package:commerce_shop_flutter/components/integral_shop/integral_detail.dart';
import 'package:commerce_shop_flutter/components/near_farm/index.dart';
import 'package:commerce_shop_flutter/components/near_farm/merchant_detail.dart';
import 'package:commerce_shop_flutter/components/welcome/login.dart';
import 'package:commerce_shop_flutter/components/welcome/register.dart';
import 'package:commerce_shop_flutter/components/coupon/index.dart';
import 'package:commerce_shop_flutter/components/coupon/take_coupon.dart';
import 'package:commerce_shop_flutter/components/user_center/setting/setting.dart';
import 'package:commerce_shop_flutter/components/user_center/setting/password.dart';
import 'package:commerce_shop_flutter/components/user_center/setting/photo.dart';
import 'package:commerce_shop_flutter/components/user_center/location/location.dart';
import 'package:commerce_shop_flutter/components/user_center/location/newAddress.dart';
import 'package:commerce_shop_flutter/components/common/loading.dart';
import 'package:commerce_shop_flutter/components/good_detail/good_cart.dart';
import 'package:commerce_shop_flutter/components/payment/index.dart';
import 'package:commerce_shop_flutter/components/good_detail/supplier.dart';
import 'package:commerce_shop_flutter/components/order/all_order.dart';
import 'package:commerce_shop_flutter/components/order/unpay_order.dart';
import 'package:commerce_shop_flutter/components/order/finish_order.dart';
import 'package:commerce_shop_flutter/components/order/cancel_order.dart';
import 'package:commerce_shop_flutter/components/farm/farm_detail.dart';
import 'package:commerce_shop_flutter/components/farm/farm_order.dart';
import 'package:commerce_shop_flutter/components/farm/user_farm.dart';
import 'package:commerce_shop_flutter/components/supplier/index.dart';
import 'package:commerce_shop_flutter/components/supplier/login.dart';
import 'package:commerce_shop_flutter/components/supplier/register.dart';
import 'package:commerce_shop_flutter/components/supplier/nextStep.dart';
import 'package:commerce_shop_flutter/components/supplier/components/publish_good.dart';
import 'package:commerce_shop_flutter/components/supplier/components/publish_land.dart';
import 'package:commerce_shop_flutter/components/supplier/components/publish_crop.dart';
import 'package:commerce_shop_flutter/components/chitchat/service.dart';
import 'package:commerce_shop_flutter/components/chitchat/message.dart';

final routes = {
  'welcome': (context) => Welcome(),
  'index': (context) => IndexPage(),
  'login': (context) => Login(),
  'register': (context) => Register(),
  'setting': (context) => Setting(),
  'homeGoodsDetail': (context, {arguments}) => GoodDetails(),
  'signIn': (context, {arguments}) => SignIn(),
  'integralMall': (context, {arguments}) => IntegralMall(),
  'integralDetail': (context, {arguments}) => IntegralDetail(),
  'nearFarm': (context, {arguments}) => NearFarm(),
  'merchant': (context, {arguments}) => Merchant(),
  'password': (context) => Password(),
  'location': (context) => Location(),
  "newAddress": (context) => NewAddress(),
  "hotNews": (context) => HotNews(),
  "coupon": (context) => Coupon(),
  "takeCoupon": (context) => TakeCoupon(),
  "newsDetail": (context, {arguments}) => NewDetails(),
  "loading": (context) => Loading(),
  "myCart": (context) => MyCart(),
  "payment": (context, {arguments}) => PayMent(),
  "supplier": (context, {arguments}) => Supplier(),
  "allOrder": (context, {arguments}) => AllOrder(),
  "unpayOrder": (context, {arguments}) => UnpayOrder(),
  "finishOrder": (context, {arguments}) => FinishOrder(),
  "cancelOrder": (context, {arguments}) => CancelOrder(),
  "farmDetail": (context, {arguments}) => FarmDetail(),
  "farmOrder": (context, {arguments}) => FarmOrder(),
  "monitor": (context, {arguments}) => Monitor(),
  "myFarm": (context, {arguments}) => MyFarm(),
  "sLogin": (context, {arguments}) => SupplierLogin(),
  "sRegister": (context, {arguments}) => SupplierRegister(),
  "nextStep": (context, {arguments}) => NextStep(),
  "supplierCenter": (context, {arguments}) => SupplierCenter(),
  "publishGood": (context, {arguments}) => PublishGood(),
  "publishLand": (context, {arguments}) => PublishLand(),
  "publishCrop": (context, {arguments}) => PublishCrop(),
  "service": (context, {arguments}) => Service(),
  "message": (context, {arguments}) => Message(),
  "photo": (context) => Photo(),
};
