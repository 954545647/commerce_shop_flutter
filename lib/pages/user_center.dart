import 'package:flutter/material.dart';
import 'package:commerce_shop_flutter/components/user_center/TopBanner.dart';
import 'package:commerce_shop_flutter/components/user_center/OrderList.dart';
import 'package:commerce_shop_flutter/components/user_center/CommonFun.dart';
// import 'package:commerce_shop_flutter/components/user_center/TopBanner.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UserCenter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance =
        ScreenUtil(width: 750, height: 1334, allowFontScaling: true)
          ..init(context);
    return Scaffold(
      body: Container(
        color: Color.fromRGBO(240, 240, 240, 1),
        child: Column(
          children: <Widget>[TopBanner(), OrderList(), CommonFun()],
        ),
      ),
    );
  }
}
