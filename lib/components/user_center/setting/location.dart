// 修改地址
import 'package:flutter/material.dart';
import 'package:commerce_shop_flutter/components/common/top_title.dart';
// import 'package:provider/provider.dart';
// import 'package:commerce_shop_flutter/provider/userData.dart';
// import 'package:commerce_shop_flutter/config/service_method.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'package:commerce_shop_flutter/utils/dio.dart';

class Location extends StatefulWidget {
  @override
  _LocationState createState() => _LocationState();
}

class _LocationState extends State<Location> {
  // GlobalKey _formKey = new GlobalKey();
  // TextEditingController _pass1Controller = new TextEditingController();
  // TextEditingController _pass2Controller = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    // final user = Provider.of<UserData>(context);
    return Scaffold(
      body: Container(
        child: Column(
          children: <Widget>[
            TopTitle(
              title: "地址管理",
              showArrow: true,
            ),
            RaisedButton(
              child: Text("获取token"),
              onPressed: () async {
                String result =
                    await DioUtils.getInstance().get('homeSwiperImgList');
              },
            )
          ],
        ),
      ),
    );
  }
}
