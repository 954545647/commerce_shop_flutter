import 'package:flutter/material.dart';
import 'package:commerce_shop_flutter/components/user_center/TopBanner.dart';
import 'package:commerce_shop_flutter/components/user_center/OrderList.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:commerce_shop_flutter/components/user_center/UserWealth.dart';
import 'package:provider/provider.dart';
import 'package:commerce_shop_flutter/provider/userData.dart';

class UserCenter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance =
        ScreenUtil(width: 750, height: 1334, allowFontScaling: true)
          ..init(context);
    final user = Provider.of<UserData>(context);

    return Scaffold(
      body: Container(
        color: Color.fromRGBO(240, 240, 240, 1),
        child: Column(
          children: <Widget>[
            TopBanner(),
            user.isLogin ? OrderList() : Container(width: 0, height: 0),
            SizedBox(
              height: 20.0,
            ),
            UserWealth(),
          ],
        ),
      ),
    );
  }
}
