// 修改地址
import 'package:flutter/material.dart';
import 'package:commerce_shop_flutter/utils/dio.dart';
import 'package:flutter/cupertino.dart';

class Location extends StatefulWidget {
  @override
  _LocationState createState() => _LocationState();
}

class _LocationState extends State<Location> {
  List addressList = [];
  @override
  void initState() {
    super.initState();
    DioUtils.getInstance().post('address').then((val) {
      if (val != null) {
        setState(() {
          addressList = val["data"];
        });
      }
    });
  }

  loadData() async {
    DioUtils.getInstance().post('address').then((val) {
      if (val != null) {
        setState(() {
          addressList = val["data"];
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "地址管理",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: getBody(),
      ),
    );
  }

  getBody() {
    if (addressList.length != 0) {
      return Stack(
        alignment: Alignment.center,
        children: <Widget>[
          ListView.builder(
              itemCount: addressList.length,
              itemBuilder: (BuildContext context, int index) {
                return singleAddress(addressList[index]);
              }),
          Positioned(
            bottom: 0,
            child: GestureDetector(
              child: Container(
                margin: EdgeInsets.only(bottom: 10.0),
                alignment: Alignment.center,
                width: 260,
                height: 30.0,
                decoration: BoxDecoration(
                    color: Colors.red,
                    // border: Border.all(width: 1),
                    borderRadius: BorderRadius.all(Radius.circular(30.0))),
                child: Text(
                  "新增地址",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              onTap: () {
                Navigator.pushNamed(context, "newAddress").then((val) {
                  if (val == true) {
                    loadData();
                  }
                });
              },
            ),
          ),
        ],
      );
    } else {
      // 加载菊花
      return CupertinoActivityIndicator();
    }
  }

  Widget singleAddress(data) {
    return Container(
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(width: 1, color: Colors.grey))),
      alignment: Alignment.center,
      height: 70.0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                margin: EdgeInsets.fromLTRB(10, 0, 15, 0),
                child: Text(
                  data["username"],
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.w400),
                ),
              ),
              Text(
                data["phone"],
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                margin: EdgeInsets.fromLTRB(10, 0, 15, 0),
                child: Text(
                  data["address"],
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                child: GestureDetector(
                  child: Icon(Icons.edit),
                  onTap: () {},
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
