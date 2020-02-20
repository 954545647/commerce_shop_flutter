// 用户地址数据
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:commerce_shop_flutter/provider/userData.dart';

class UserAdress extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserData>(context);
    var userInfo = user.userInfo;
    bool hasAddress = userInfo.address == "";
    return Container(
      height: 100,
      margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
      decoration: BoxDecoration(
          border: Border.all(width: 1),
          color: Colors.white,
          borderRadius: BorderRadius.circular(15)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Icon(Icons.location_city, size: 30),
          !hasAddress
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(userInfo.username),
                        Text(userInfo.phone)
                      ],
                    ),
                    Text(userInfo.address)
                  ],
                )
              : GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, "newAddress");
                  },
                  child: Container(
                    child: Text("点击前往添加地址"),
                  ),
                ),
          Icon(Icons.arrow_forward, size: 30)
        ],
      ),
    );
  }
}
