import 'package:flutter/material.dart';
// import 'package:redux/redux.dart';
// import 'package:flutter_redux/flutter_redux.dart';
// import 'package:commerce_shop_flutter/model/state.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
            Expanded(
              child: Column(
                children: <Widget>[Text('15'), Text('我的积分')],
              ),
            ),
            Expanded(
              child: Column(
                children: <Widget>[Text('15'), Text('我的积分')],
              ),
            ),
            Expanded(
              child: Column(
                children: <Widget>[Text('15'), Text('我的积分')],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
