// 用户地址数据
import 'package:flutter/material.dart';
import 'package:commerce_shop_flutter/utils/dio.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:commerce_shop_flutter/provider/orderData.dart';
import 'package:commerce_shop_flutter/provider/userData.dart';

class UserAddress extends StatefulWidget {
  @override
  _UserAddressState createState() => new _UserAddressState();
}

class _UserAddressState extends State<UserAddress> {
  OrderData orderdata;
  UserData userdata;
  var userDefaultAddress;
  List userAddress = [];
  @override
  void initState() {
    super.initState();
    getDefaultAddress();
  }

  // 获取用户默认地址
  Future<void> getDefaultAddress() async {
    Future.delayed(Duration(microseconds: 300), () async {
      orderdata = Provider.of<OrderData>(context);
      userdata = Provider.of<UserData>(context);
      await DioUtil.getInstance(context).get("address").then((val) {
        if (val != null && val["data"] != null) {
          var list = val["data"];
          var address = [];
          var defaultList = [];
          list.forEach((item) {
            if (item["isDefault"] == true) {
              // 默认地址
              defaultList.add(item);
            } else {
              address.add(item);
            }
          });
          if (defaultList.length == 0) {
            if (address.length == 0) {
              userDefaultAddress = "";
            } else {
              // 如果没有默认地址，则取地址的第一个
              userDefaultAddress = address[0];
            }
          } else {
            userDefaultAddress = defaultList[0];
          }
          userAddress = list;
          setState(() {});
        }
      });
      String res =
          userDefaultAddress != "" ? userDefaultAddress["address"] : "";
      orderdata.addAddress(userdata.userInfo.id, res);
    });
  }

  void setOrderAddress(String address) {
    orderdata.addAddress(userdata.userInfo.id, address);
  }

  @override
  Widget build(BuildContext context) {
    if (userDefaultAddress != null && userDefaultAddress != "") {
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
                    Text(userDefaultAddress["username"]),
                    SizedBox(
                      width: 10,
                    ),
                    Text(userDefaultAddress["phone"])
                  ],
                ),
                Text(userDefaultAddress["address"])
              ],
            ),
            InkWell(
              child: Icon(Icons.more, size: 30),
              onTap: () {
                showModalBottomSheet(
                    context: context,
                    builder: (context) => Container(
                          color: Colors.white,
                          height: 300,
                          child: ListView(
                            children: <Widget>[
                              Container(
                                alignment: Alignment.center,
                                height: 80,
                                child: Text(
                                  "地址列表",
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              addressList()
                            ],
                          ),
                        ));
              },
            )
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
                Navigator.pushNamed(context, "newAddress").then((val) {
                  if (val == true) {
                    getDefaultAddress();
                  }
                });
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

  Widget addressList() {
    List<Widget> list = [];
    for (int i = 0; i < userAddress.length; i++) {
      list.add(addressItem(userAddress[i]));
    }
    return Column(children: list);
  }

  Widget addressItem(data) {
    return GestureDetector(
      onTap: () {
        userDefaultAddress = data;
        setOrderAddress(userDefaultAddress["address"]);
        setState(() {});
        Navigator.pop(context);
      },
      child: Container(
        alignment: Alignment.center,
        width: ScreenUtil().setWidth(750),
        margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
        height: 60,
        decoration: BoxDecoration(
            border: Border.all(width: 1),
            borderRadius: BorderRadius.circular(15)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Text(
              data["username"],
              style: TextStyle(color: Colors.red),
            ),
            Text(data["address"])
          ],
        ),
      ),
    );
  }
}
