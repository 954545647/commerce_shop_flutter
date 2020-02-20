// 用户地址数据
import 'package:flutter/material.dart';
import 'package:commerce_shop_flutter/utils/dio.dart';

class UserAddress extends StatefulWidget {
  @override
  _UserAddressState createState() => new _UserAddressState();
}

class _UserAddressState extends State<UserAddress> {
  var userDefaultAddress;
  @override
  void initState() {
    super.initState();
    getDefaultAddress();
  }

  getDefaultAddress() {
    DioUtils.getInstance().get("address").then((val) {
      if (val != null && val["data"] != null) {
        var list = val["data"];
        var address = [];
        var defaultList = [];
        list.forEach((item) {
          if (item["isDefault"] == true) {
            defaultList.add(item);
          } else {
            address.add(item);
          }
        });
        if (defaultList.length == 0) {
          if (address.length == 0) {
            userDefaultAddress = [];
          } else {
            userDefaultAddress = [address[0]];
          }
        } else {
          userDefaultAddress = [defaultList[0]];
        }
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (userDefaultAddress != null && userDefaultAddress.length > 0) {
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
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(userDefaultAddress[0]["username"]),
                    Text(userDefaultAddress[0]["phone"])
                  ],
                ),
                Text(userDefaultAddress[0]["address"])
              ],
            ),
            Icon(Icons.arrow_forward, size: 30)
          ],
        ),
      );
    } else {
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
            GestureDetector(
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
}
