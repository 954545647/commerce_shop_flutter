// 商家注册页面
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:commerce_shop_flutter/utils/dio.dart';
import 'package:commerce_shop_flutter/components/common/toast.dart';
import 'package:commerce_shop_flutter/utils/utils.dart';

class SupplierRegister extends StatefulWidget {
  @override
  _SupplierRegisterState createState() => _SupplierRegisterState();
}

class _SupplierRegisterState extends State<SupplierRegister> {
  TextEditingController _unameController = new TextEditingController(); // 用户名
  TextEditingController _pwdController = new TextEditingController(); // 密码
  TextEditingController _phoneController = new TextEditingController(); // 手机号
  TextEditingController _checkCodeController =
      new TextEditingController(); // 验证码
  GlobalKey _formKey = new GlobalKey<FormState>();
  final int countdown = 60;
  bool _isAvailableGetVCode = true; //是否可以获取验证码，默认为`false`
  String _verifyStr = "发送验证码";
  // 倒计时的计时器。
  Timer _timer;
  // 当前倒计时的秒数。
  int _seconds = 60;
  bool checkOk = false; // 是否通过验证

// 开始倒计时
  _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _seconds--;
      _isAvailableGetVCode = false;
      _verifyStr = '已发送(${_seconds}s)';
      if (_seconds == 0) {
        _verifyStr = '重新获取';
        _isAvailableGetVCode = true;
        _seconds = countdown;
        _cancelTimer();
      }
      setState(() {});
    });
  }

  // 跳转注册下一步
  void jumpNextStep() {
    // 关闭键盘
    FocusScope.of(context).requestFocus(FocusNode());
    Navigator.pushNamed(context, "nextStep", arguments: {
      "username": _unameController.text,
      "password": _pwdController.text,
      "phone": _phoneController.text
    });
    _cancelTimer();
  }

  // 检查名字是否存在
  Future<bool> checkNameExit() async {
    bool ifExit = false;
    var data = await DioUtil.getInstance(context)
        .post("SsupplierIfExit", data: {"username": _unameController.text});
    // 查找到有数据 或者 传参不符合规范
    if (data != null && data["code"] == 400) {
      Toast.toast(context, msg: parseErrorMessage(data["msg"]));
      ifExit = true;
    }
    return ifExit;
  }

  // 检查验证码
  Future<bool> checkCode() async {
    bool result = false;
    var data = await getData("user/checkVerifyCode", data: {
      "phone": _phoneController.text,
      "verifyCode": _checkCodeController.text
    });
    if (data != null && data["code"] == 200) {
      result = true;
    } else {
      Toast.toast(context, msg: data["msg"]);
    }
    return result;
  }

  // 取消倒计时的计时器。
  void _cancelTimer() {
    // 计时器（`Timer`）组件的取消（`cancel`）方法，取消计时器。
    _timer?.cancel();
  }

  @override
  void dispose() {
    super.dispose();
    _unameController.dispose();
    _pwdController.dispose();
    _phoneController.dispose();
    _checkCodeController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance =
        ScreenUtil(width: 750, height: 1334, allowFontScaling: true)
          ..init(context);
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                  alignment: Alignment.bottomLeft,
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  height: ScreenUtil().setHeight(240),
                  child: Text("商家注册",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold))),
              Expanded(
                flex: 1,
                child: ListView(
                  children: <Widget>[
                    Form(
                      key: _formKey,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            TextFormField(
                              controller: _unameController,
                              decoration: InputDecoration(
                                  labelText: '用户名', icon: Icon(Icons.person)),
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
                                  return v.trim().length > 2
                                      ? null
                                      : "密码不能少于6位";
                                }),
                            Stack(
                              children: <Widget>[
                                TextFormField(
                                    controller: _phoneController,
                                    keyboardType: TextInputType.number,
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
                                      RegExp mobile =
                                          new RegExp(r"^1[3-9]\d{9}$");
                                      if (mobile.hasMatch(v)) {
                                        return null;
                                      } else {
                                        return "手机格式不正确";
                                      }
                                    }),
                                Positioned(
                                  right: 0,
                                  top: 10,
                                  child: RaisedButton(
                                    child: Text(_verifyStr),
                                    onPressed: () async {
                                      if (_phoneController.text == "") {
                                        Toast.toast(context, msg: "请先填写手机号码");
                                      } else if (_isAvailableGetVCode ==
                                          false) {
                                        Toast.toast(context,
                                            msg: "一分钟只能获取一次验证码");
                                      } else {
                                        getData("user/sendSms", data: {
                                          "phone": _phoneController.text
                                        }).then((val) {
                                          _startTimer();
                                          Toast.toast(context,
                                              msg: "短信已发送，请查收手机短信");
                                        });
                                      }
                                    },
                                  ),
                                )
                              ],
                            ),
                            TextFormField(
                                keyboardType: TextInputType.number,
                                controller: _checkCodeController,
                                decoration: InputDecoration(
                                    labelText: "验证码",
                                    hintText: "输入6位数验证码",
                                    icon: Icon(
                                      IconData(0xe64a, fontFamily: 'myIcons'),
                                      size: 20,
                                    )),
                                //校验密码
                                validator: (v) {
                                  return v.trim().length == 6
                                      ? null
                                      : "验证码为6位数字";
                                }),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                SizedBox(
                                  width: 100,
                                ),
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
                                      // 校验名字是否存在
                                      bool result = await checkNameExit();
                                      if (result) {
                                        return;
                                      }
                                      // 校验验证码
                                      bool ifCodeTrue = await checkCode();
                                      if (ifCodeTrue) {
                                        jumpNextStep();
                                      }
                                    }
                                  },
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.popAndPushNamed(context, "sLogin");
                },
                child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    height: ScreenUtil().setHeight(100),
                    child: Text("Already have an account? Sign In Now",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ))),
              ),
              SizedBox(
                height: 30,
              ),
            ],
          ),
        ));
  }
}
