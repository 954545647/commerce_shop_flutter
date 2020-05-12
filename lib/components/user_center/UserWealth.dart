import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:commerce_shop_flutter/components/common/list_item.dart';

class UserWealth extends StatefulWidget {
  @override
  _UserWealthState createState() => _UserWealthState();
}

class _UserWealthState extends State<UserWealth> {
  List funList = [
    ListItem(
      title: "我的地块",
      onChanged: () {},
      iconName: "0xe62a",
      jumpRoute: "myFarm",
    ),
    ListItem(
      title: "我的积分",
      onChanged: () {},
      iconName: "0xe610",
      jumpRoute: "integralDetail",
    ),
    ListItem(
      title: "优惠券",
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
      title: "更换头像",
      onChanged: () {},
      iconName: "0xe6b0",
      jumpRoute: "photo",
    ),
    ListItem(
      title: "设置",
      onChanged: () {},
      iconName: "0xe733",
      jumpRoute: "setting",
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil.getInstance().setWidth(750),
      height: ScreenUtil.getInstance().setHeight(560),
      margin: EdgeInsets.fromLTRB(20, 20, 15, 0),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(15)),
      child: GridView.builder(
        itemCount: funList.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 1,
        ),
        physics: NeverScrollableScrollPhysics(), // 禁止回弹
        itemBuilder: (context, index) {
          return funList[index];
        },
      ),
    );
  }
}
