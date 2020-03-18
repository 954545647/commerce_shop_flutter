import 'package:flutter/material.dart';
import 'package:commerce_shop_flutter/utils/dio.dart';
import './farm.dart';
import 'package:commerce_shop_flutter/provider/userData.dart';
import 'package:provider/provider.dart';

class FarmList extends StatefulWidget {
  @override
  _FarmListState createState() => _FarmListState();
}

class _FarmListState extends State<FarmList> {
  List farmList = [];
  @override
  void initState() {
    super.initState();
    getFarmList();
  }

// 获取农场信息
  getFarmList() {
    DioUtil.getInstance(context).get("getAllFarmsInfo").then((val) {
      if (val != null && val["data"] != null) {
        setState(() {
          farmList = val["data"];
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserData>(context);
    bool isLogin = user.isLogin;
    return Container(
      child: SingleChildScrollView(
        child: Column(
            children: farmList.map((farmInfo) {
          return Farm(farmInfo: farmInfo, isLogin: isLogin);
        }).toList()),
      ),
    );
  }
}
