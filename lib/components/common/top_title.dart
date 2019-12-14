import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TopTitle extends StatelessWidget {
  final String title;
  TopTitle({this.title});
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            border:
                Border(bottom: BorderSide(width: 1, color: Colors.black12))),
        alignment: Alignment.center,
        height: ScreenUtil().setHeight(150),
        padding: EdgeInsets.only(top: 20.0),
        child: Text(title,
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)));
  }
}
