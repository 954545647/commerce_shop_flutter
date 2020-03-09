import 'package:flutter/material.dart';
import 'package:commerce_shop_flutter/components/common/top_title.dart';
import 'components/order_manage.dart';
import 'components/good_manage.dart';
import 'components/land_manage.dart';
import 'components/user_manage.dart';

class SupplierCenter extends StatefulWidget {
  @override
  _SupplierCenterState createState() => _SupplierCenterState();
}

class _SupplierCenterState extends State<SupplierCenter> {
  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> info = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      body: Container(
        color: Color.fromRGBO(240, 240, 240, 1),
        child: Column(
          children: <Widget>[
            TopTitle(
              title: "商家中心",
              showArrow: true,
            ),
            OrderManage(info),
            GoodManage(info),
            LandManage(info),
            UserManage(),
          ],
        ),
      ),
    );
  }
}
