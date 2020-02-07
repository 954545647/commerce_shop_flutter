import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Welcome extends StatefulWidget {
  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
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
                  "assets/images/welcome.webp",
                  fit: BoxFit.cover,
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
                        GestureDetector(
                            child: Container(
                              width: ScreenUtil().setWidth(450),
                              height: ScreenUtil().setHeight(80),
                              child: Center(
                                  child: Text('Login',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14.0))),
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.red),
                                  borderRadius: BorderRadius.circular(5.0),
                                  color: Color.fromRGBO(244, 66, 53, 1)),
                            ),
                            onTap: () {
                              Navigator.pushNamed(context, 'login');
                            }),
                        GestureDetector(
                            child: Container(
                              width: ScreenUtil().setWidth(450),
                              height: ScreenUtil().setHeight(80),
                              margin: EdgeInsets.only(top: 20.0),
                              child: Center(
                                  child: Text('SIGN UP',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14.0))),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.white),
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                            ),
                            onTap: () {
                              Navigator.pushNamed(context, 'register');
                            }),
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
