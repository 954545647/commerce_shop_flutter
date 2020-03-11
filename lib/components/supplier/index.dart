import 'package:flutter/material.dart';
import 'components/order_manage.dart';
import 'components/good_manage.dart';
import 'components/land_manage.dart';
import 'package:provider/provider.dart';
import 'package:commerce_shop_flutter/provider/supplierData.dart';
import 'components/user_manage.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SupplierCenter extends StatefulWidget {
  @override
  _SupplierCenterState createState() => _SupplierCenterState();
}

class _SupplierCenterState extends State<SupplierCenter> {
  SupplierData supplierData;
  @override
  void initState() {
    super.initState();
    _initSupplierData();
  }

  Future<void> _initSupplierData() async {
    await Future.delayed(Duration(microseconds: 300), () async {
      supplierData = Provider.of<SupplierData>(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color.fromRGBO(240, 240, 240, 1),
        child: Column(
          children: <Widget>[
            Container(
              color: Colors.white,
              height: ScreenUtil().setHeight(150),
              alignment: Alignment.center,
              padding: EdgeInsets.only(top: 20),
              child: ConstrainedBox(
                constraints: BoxConstraints.expand(),
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Text("商家中心",
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
                          Navigator.popAndPushNamed(context, "index");
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
            OrderManage(),
            GoodManage(),
            LandManage(),
            UserManage(),
          ],
        ),
      ),
    );
  }
}
