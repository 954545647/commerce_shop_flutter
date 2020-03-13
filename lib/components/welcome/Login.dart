import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:commerce_shop_flutter/provider/userData.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:commerce_shop_flutter/components/common/toast.dart';
import 'package:commerce_shop_flutter/utils/dio.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  // 定义 Controller
  TextEditingController _unameController = new TextEditingController();
  TextEditingController _pwdController = new TextEditingController();
  GlobalKey _formKey = new GlobalKey<FormState>();
  String userAddress;

  @override
  void initState() {
    super.initState();
  }

  // 获取用户地址
  getUserAddress() async {
    await DioUtils.getInstance().get('address').then((val) {
      if (val != null && val["data"] != null) {
        if (val["data"].length == 0) {
          userAddress = "";
        } else {
          userAddress = val["data"][0]["address"];
        }
        setState(() {});
      }
    });
  }

  // 登录
  Future login() async {
    return DioUtils.getInstance().post('login', data: {
      "username": _unameController.text,
      "password": _pwdController.text
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance =
        ScreenUtil(width: 750, height: 1334, allowFontScaling: true)
          ..init(context);
    final user = Provider.of<UserData>(context);
    return Material(
      child: Container(
        color: Colors.white,
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
                      Navigator.pop(context);
                    })),
            Positioned(
              left: 5.0,
              top: 90.0,
              child: Text(
                'Login',
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
                height: ScreenUtil().setHeight(700),
                child: Form(
                    key: _formKey, // 获取 FormState
                    // autovalidate: true, // 自动校验
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          TextFormField(
                            controller: _unameController, // 用于获取输入的文本
                            decoration: InputDecoration(
                                labelText: '用户名',
                                hintText: '用户名或邮箱',
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
                              obscureText: true, // 隐藏正在输入的内容
                              //校验密码
                              validator: (v) {
                                return v.trim().length > 2 ? null : "密码不能少于3位";
                              }),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  InkWell(
                                    child: Container(
                                      margin: EdgeInsets.fromLTRB(0, 30, 30, 0),
                                      child: Text(
                                        'No account yet. Sign up for one?',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    onTap: () {
                                      Navigator.pushNamed(context, 'register');
                                    },
                                  ),
                                  GestureDetector(
                                      child: Container(
                                        height: ScreenUtil().setHeight(100),
                                        width: ScreenUtil().setWidth(100),
                                        margin: EdgeInsets.only(top: 30.0),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(60.0),
                                            color:
                                                Color.fromRGBO(208, 1, 27, 1)),
                                        child: Icon(Icons.keyboard_arrow_right,
                                            size: 30, color: Colors.white),
                                      ),
                                      onTap: () async {
                                        /*
                                        Form.of(context).validate(); // 不行
                                        这里的 context 是 Login 的 context
                                        而Form.of(context)是根据所指定context向根去查找
                                        而 FormState 是在 Login 的子树中，所以查找不到
                                      */
                                        if ((_formKey.currentState as FormState)
                                            .validate()) {
                                          var data = await login();
                                          if (data != null) {
                                            if (data["errorCode"] == 0) {
                                              var res = data["data"];
                                              // 将token保存到本地缓存中
                                              SharedPreferences prefs =
                                                  await SharedPreferences
                                                      .getInstance();
                                              prefs.setString(
                                                  "token", res["token"]);
                                              await getUserAddress();
                                              // 将用户信息注册到全局上
                                              user.login(
                                                  id: res["id"],
                                                  username: res["username"],
                                                  phone: res["phone"],
                                                  address: userAddress,
                                                  imgCover: res["imgCover"],
                                                  unpayOrder: []);
                                              // socket连接
                                              user.connect();
                                              FocusScope.of(context)
                                                  .requestFocus(FocusNode());
                                              Navigator.pushNamed(
                                                  context, 'index');
                                            } else {
                                              Toast.toast(context,
                                                  msg: data["msg"]);
                                            }
                                          } else {
                                            Toast.toast(context, msg: "登录失败");
                                          }
                                        }
                                      })
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
