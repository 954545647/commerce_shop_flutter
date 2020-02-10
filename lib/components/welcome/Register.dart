import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:commerce_shop_flutter/config/service_method.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController _unameController = new TextEditingController(); // 用户名
  TextEditingController _pwdController = new TextEditingController(); // 密码
  TextEditingController _phoneController = new TextEditingController(); // 手机号
  TextEditingController _checkCodeController =
      new TextEditingController(); // 验证码
  GlobalKey _formKey = new GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance =
        ScreenUtil(width: 750, height: 1334, allowFontScaling: true)
          ..init(context);
    return Material(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
        child: Stack(
          children: <Widget>[
            // 返回按钮
            Positioned(
                left: 0.0,
                top: 25.0,
                child: InkWell(
                    child: Icon(
                      Icons.close,
                      color: Colors.black,
                      size: 30.0,
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, 'welcome');
                    })),
            Positioned(
              left: 5.0,
              top: 90.0,
              child: Text(
                'Sign Up',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Positioned(
              top: 150.0,
              child: Container(
                width: ScreenUtil().setWidth(680),
                child: Form(
                    key: _formKey,
                    // autovalidate: true,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          TextFormField(
                            controller: _unameController,
                            decoration: InputDecoration(
                                labelText: '用户名',
                                hintText: '用户名或手机号',
                                icon: Icon(Icons.person)),
                            validator: (v) {
                              return v.trim().length > 0 ? null : '用户名不能为空';
                            },
                          ),
                          TextFormField(
                              controller: _pwdController,
                              decoration: InputDecoration(
                                  labelText: "密码",
                                  hintText: "您的登录密码",
                                  icon: Icon(Icons.lock)),
                              obscureText: true,
                              //校验密码
                              validator: (v) {
                                return v.trim().length > 2 ? null : "密码不能少于6位";
                              }),
                          TextFormField(
                              controller: _phoneController,
                              decoration: InputDecoration(
                                  labelText: "手机号",
                                  hintText: "关联您的手机号码",
                                  icon: Icon(Icons.phone_iphone)),
                              // 校验手机号
                              validator: (v) {
                                int count = v.trim().length;
                                if (count != 11) {
                                  return "手机号必须是11位";
                                }
                                RegExp mobile = new RegExp(r"^1[3-9]\d{9}$");
                                if (mobile.hasMatch(v)) {
                                  return null;
                                } else {
                                  return "手机格式不正确";
                                }
                              }),
                          TextFormField(
                            controller: _checkCodeController,
                            decoration: InputDecoration(
                                labelText: "验证码",
                                hintText: "输入6位数验证码",
                                icon: Icon(
                                  IconData(0xe64a, fontFamily: 'myIcons'),
                                  size: 20,
                                )),
                            // obscureText: true,
                            //校验密码
                            // validator: (v) {
                            //   return v.trim().length > 5
                            //       ? null
                            //       : "密码不能少于6位";
                            // }
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  GestureDetector(
                                    child: Container(
                                      height: ScreenUtil().setHeight(100),
                                      width: ScreenUtil().setWidth(100),
                                      margin: EdgeInsets.only(top: 30.0),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(60.0),
                                          color: Color.fromRGBO(208, 1, 27, 1)),
                                      child: Icon(Icons.keyboard_arrow_right,
                                          size: 30, color: Colors.white),
                                    ),
                                    onTap: () async {
                                      if ((_formKey.currentState as FormState)
                                          .validate()) {
                                        var data = await getData("register",
                                            formdata: {
                                              "username": _unameController.text,
                                              "password": _pwdController.text,
                                              "phone": _phoneController.text,
                                              "verifiCode":
                                                  _checkCodeController.text
                                            });
                                        print('${data}6666');
                                        if (data["errorCode"] == 0) {
                                          Navigator.pushNamed(context, 'login');
                                        } else {
                                          print(data["msg"]);
                                        }
                                      }
                                    },
                                  )
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                    )),
              ),
            ),
            Positioned(
              bottom: 30,
              child: InkWell(
                child: Container(
                  alignment: Alignment.center,
                  width: ScreenUtil().setWidth(680),
                  margin: EdgeInsets.fromLTRB(0, 30, 30, 0),
                  child: Text(
                    'Already have an account? Sign In',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                onTap: () {
                  Navigator.pushNamed(context, 'login');
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
