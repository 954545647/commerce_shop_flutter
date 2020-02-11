import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TopTitle extends StatelessWidget {
  final String title;
  final double top;
  final bool showArrow;
  final ifRefresh;
  TopTitle(
      {this.title, this.top = 20, this.showArrow = false, this.ifRefresh = ""});
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            border: Border(bottom: BorderSide(width: 1, color: Colors.black12)),
            color: Colors.white),
        alignment: Alignment.center,
        height: ScreenUtil().setHeight(150),
        padding: EdgeInsets.only(top: top),
        child: ConstrainedBox(
          constraints: BoxConstraints.expand(),
          child: showArrow
              ? Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Text(title,
                        style: TextStyle(
                            color: Colors.black,
                            decoration: TextDecoration.none,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold)),
                    Positioned(
                      left: 10,
                      child: GestureDetector(
                        child: Icon(
                          Icons.chevron_left,
                          size: 30,
                          color: Colors.grey,
                        ),
                        onTap: () {
                          Navigator.pop(context, ifRefresh);
                        },
                      ),
                    )
                  ],
                )
              : Container(
                  alignment: Alignment.center,
                  height: ScreenUtil().setHeight(150),
                  child: Text(title,
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold)),
                ),
        ));
  }
}
