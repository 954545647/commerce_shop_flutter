import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:async';

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
    startCountdownTimer();
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
