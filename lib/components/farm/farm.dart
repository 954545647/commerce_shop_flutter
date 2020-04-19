import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:commerce_shop_flutter/utils/diaLog.dart';
import "package:commerce_shop_flutter/config/config.dart";

class Farm extends StatelessWidget {
  final farmInfo;
  final bool isLogin;
  Farm({this.farmInfo, this.isLogin});
  @override
  Widget build(BuildContext context) {
    var farmDetail = farmInfo["farmInfo"];
    return Container(
        width: ScreenUtil().setWidth(750),
        margin: EdgeInsets.fromLTRB(15, 15, 15, 0),
        padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
        decoration: BoxDecoration(
            border: Border.all(width: 1),
            color: Colors.white,
            borderRadius: BorderRadius.circular(8)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
                width: ScreenUtil().setWidth(720),
                height: ScreenUtil().setHeight(450),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                        image: NetworkImage(
                            "${Config.apiHost}/${farmDetail["imgCover"]}"),
                        fit: BoxFit.fill))),
            SizedBox(height: 10),
            Text(
              farmDetail["farmName"],
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Text(
                farmDetail["address"],
                maxLines: 2,
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Text(
                  "￥${farmDetail["preArea"]}",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    if (isLogin) {
                      Navigator.pushNamed(context, "farmDetail",
                          arguments: farmDetail);
                    } else {
                      loginDialog(context, "请前往登录");
                    }
                  },
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Color.fromRGBO(50, 117, 116, 1)),
                    width: ScreenUtil().setWidth(200),
                    height: ScreenUtil().setHeight(80),
                    child: Text(
                      "前往租地",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                )
              ],
            )
          ],
        ));
  }
}
