import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import './../model/state.dart';
import 'package:commerce_shop_flutter/pages/index.dart';
import 'package:commerce_shop_flutter/components/welcome/Login.dart';
import 'package:commerce_shop_flutter/components/welcome/UserCenter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_redux/flutter_redux.dart';

class Welcome extends StatefulWidget {
  final int counter;
  final String userName;
  final bool isLogin;
  Welcome({this.counter, this.userName, this.isLogin});
  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  int _count = 3;
  Timer _timer;
  @override
  initState() {
    super.initState();
    this._timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      if (this._count <= 1) {
        this._cancelTimer();
        this._jumpToHomePage();
      } else {
        setState(() {
          // this._count -= 1;
        });
      }
    });
  }

  _jumpToHomePage() {
    // 路由跳转，取消返回
    Navigator.of(context).pushAndRemoveUntil(
        new MaterialPageRoute(builder: (context) => new IndexPage()),
        (route) => route == null);
  }

  // 清除定时器
  _cancelTimer() {
    this._timer.cancel();
    this._timer = null;
  }

  @override
  void dispose() {
    super.dispose();
    if (this._timer != null) {
      this._cancelTimer();
    }
  }

  @override
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
                right: 20.0,
                top: 50.0,
                child: InkWell(
                  onTap: () {
                    _jumpToHomePage();
                  },
                  child: Container(
                      height: 30.0,
                      width: 80.0,
                      // alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Color.fromRGBO(113, 110, 111, 1),
                      ),
                      child: Center(
                        child: Text(
                          '跳过$_count',
                          style: TextStyle(fontSize: 16.0, color: Colors.white),
                        ),
                      )),
                ),
              ),
              Positioned(
                bottom: 50.0,
                child: Container(
                  alignment: Alignment.center,
                  width: ScreenUtil().setWidth(750),
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        RaisedButton(
                          child: Text('LOGIN'),
                          onPressed: () {
                            Navigator.pushNamed(context, '/login');
                          },
                        ),
                        RaisedButton(
                          child: Text('SIGN UP'),
                          onPressed: () {
                            Navigator.pushNamed(context, '/home');
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        value: SystemUiOverlayStyle.dark,
      ),
    );
  }
}
