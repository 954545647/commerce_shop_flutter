import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:commerce_shop_flutter/components/common/list_item.dart';

class UserWealth extends StatefulWidget {
  @override
  _UserWealthState createState() => _UserWealthState();
}

class _UserWealthState extends State<UserWealth> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: ScreenUtil().setWidth(700),
        // height: ScreenUtil().setHeight(120),
        padding: EdgeInsets.all(15.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0), color: Colors.white),
        child: Row(
          children: <Widget>[
            ListItem(
              title: "我的积分",
              onChanged: () {},
              iconName: "0xe684",
              jumpRoute: "integralDetail",
            ),
            ListItem(
              title: "优惠卷",
              onChanged: () {},
              iconName: "0xe60e",
              jumpRoute: "coupon",
            ),
            ListItem(
              title: "收货地址",
              onChanged: () {},
              iconName: "0xe778",
              jumpRoute: "location",
            ),
            ListItem(
              title: "设置",
              onChanged: () {},
              iconName: "0xe733",
              jumpRoute: "setting",
            ),
          ],
        ),
      ),
    );
  }
}
