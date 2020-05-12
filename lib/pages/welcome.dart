import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:commerce_shop_flutter/utils/dio.dart';
import 'package:provider/provider.dart';
import 'package:commerce_shop_flutter/provider/userData.dart';
import 'package:commerce_shop_flutter/provider/supplierData.dart';
import 'package:commerce_shop_flutter/provider/socketData.dart';

// 欢迎页，定时三秒后进入首页
class Welcome extends StatefulWidget {
  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  Timer _timer;
  int _count = 3;

  @override
  void initState() {
    super.initState();
    initProject();
    startCountdownTimer();
  }

  // 初始化
  initProject() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // 顾客信息
    String refreshToken = prefs.get("refreshToken");
    // 如果有token，则直接登录获取用户数据
    if (refreshToken != null) {
      int userId = prefs.get("userId");
      // 根据用户id去获取用户信息并更改登录状态
      getUserInfo(userId);
    }
    // 商家信息
    String srefreshToken = prefs.get("SrefreshToken");
    // 如果有token，则直接登录获取商家数据
    if (srefreshToken != null) {
      int supplierId = prefs.get("supplierId");
      getSupplierInfo(supplierId);
    }
  }

  // 获取顾客信息
  getUserInfo(userId) async {
    final user = Provider.of<UserData>(context);
    final socket = Provider.of<SocketData>(context);
    var data = await DioUtil.getInstance(context)
        .post('getUserInfo', data: {"id": userId});
    // 获取用户默认地址
    if (data != null && data["code"] == 200) {
      var res = data["data"];
      user.login(
          id: res["id"],
          username: res["username"],
          phone: res["phone"],
          address: "",
          imgCover: res["imgCover"],
          unpayOrder: []);
      // 重新连接socket
      socket.connect();
    }
  }

  // 获取商家信息
  getSupplierInfo(supplierId) async {
    final supplier = Provider.of<SupplierData>(context);
    var data = await DioUtil.getInstance(context)
        .post('SgetSupplierInfo', data: {"id": supplierId});
    if (data != null && data["code"] == 200) {
      var res = data["data"];
      supplier.login(
          id: res["id"],
          username: res["username"],
          imgCover: res["imgCover"],
          phone: res["phone"]);
      // 重新连接socket
      supplier.connect();
    }
  }

  void startCountdownTimer() {
    const oneSec = const Duration(seconds: 1);

    _timer = new Timer.periodic(oneSec, (Timer timer) {
      if (_count == 0) {
        timer.cancel();
        Navigator.pushNamed(context, "index");
        return;
      }
      setState(() {
        _count = _count - 1;
      });
    });
  }

  void dispose() {
    super.dispose();
    if (_timer != null) {
      _timer.cancel();
    }
  }

  Widget build(BuildContext context) {
    ScreenUtil.instance =
        ScreenUtil(width: 750, height: 1334, allowFontScaling: true)
          ..init(context);
    return Container(
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        child: Scaffold(
          body: Stack(
            children: <Widget>[
              Container(
                width: double.infinity,
                height: double.infinity,
                child: Image.asset(
                  "assets/images/welcome2.jpg",
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                bottom: 25.0,
                right: 10.0,
                child: RaisedButton(
                  child: Text("跳过"),
                  onPressed: () {
                    if (_timer != null) {
                      _timer.cancel();
                    }
                    Navigator.pushNamed(context, "index");
                  },
                ),
              )
              // Positioned(
              //   bottom: 50.0,
              //   child: Container(
              //     alignment: Alignment.center,
              //     width: ScreenUtil().setWidth(750),
              //     child: Center(
              //       child: Column(
              //         crossAxisAlignment: CrossAxisAlignment.center,
              //         children: <Widget>[
              //           GestureDetector(
              //               child: Container(
              //                 width: ScreenUtil().setWidth(450),
              //                 height: ScreenUtil().setHeight(80),
              //                 child: Center(
              //                     child: Text('Login',
              //                         style: TextStyle(
              //                             color: Colors.white,
              //                             fontSize: 14.0))),
              //                 decoration: BoxDecoration(
              //                     border: Border.all(color: Colors.red),
              //                     borderRadius: BorderRadius.circular(5.0),
              //                     color: Color.fromRGBO(244, 66, 53, 1)),
              //               ),
              //               onTap: () {
              //                 Navigator.pushNamed(context, 'login');
              //               }),
              //           GestureDetector(
              //               child: Container(
              //                 width: ScreenUtil().setWidth(450),
              //                 height: ScreenUtil().setHeight(80),
              //                 margin: EdgeInsets.only(top: 20.0),
              //                 child: Center(
              //                     child: Text('SIGN UP',
              //                         style: TextStyle(
              //                             color: Colors.white,
              //                             fontSize: 14.0))),
              //                 decoration: BoxDecoration(
              //                   border: Border.all(color: Colors.white),
              //                   borderRadius: BorderRadius.circular(5.0),
              //                 ),
              //               ),
              //               onTap: () {
              //                 Navigator.pushNamed(context, 'register');
              //               }),
              //         ],
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
        value: SystemUiOverlayStyle.dark,
      ),
    );
  }
}
