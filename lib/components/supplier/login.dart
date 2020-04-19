import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:commerce_shop_flutter/components/common/toast.dart';
import 'package:commerce_shop_flutter/utils/dio.dart';
import 'package:provider/provider.dart';
import 'package:commerce_shop_flutter/provider/supplierData.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SupplierLogin extends StatefulWidget {
  @override
  _SupplierLoginState createState() => _SupplierLoginState();
}

class _SupplierLoginState extends State<SupplierLogin> {
  // 定义 Controller
  TextEditingController _unameController = new TextEditingController();
  TextEditingController _pwdController = new TextEditingController();
  GlobalKey _formKey = new GlobalKey<FormState>();
  String userAddress;

  @override
  void initState() {
    super.initState();
  }

  // 登录
  Future login() async {
    return DioUtil.getInstance(context).post('Sslogin', data: {
      "username": _unameController.text,
      "password": _pwdController.text
    });
  }

  // 商家上线socket
  void supplierLogin(IO.Socket socket, supplierInfo) {
    socket.emit("supplierLogin",
        {"fromId": supplierInfo.id, "username": supplierInfo.username});
  }

  // 清空表单
  void reset() {
    _unameController.text = "";
    _pwdController.text = "";
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance =
        ScreenUtil(width: 750, height: 1334, allowFontScaling: true)
          ..init(context);
    final supplier = Provider.of<SupplierData>(context);
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
                      Icons.chevron_left,
                      color: Colors.black,
                      size: 35.0,
                    ),
                    onTap: () {
                      Navigator.popAndPushNamed(context, "index");
                    })),
            Positioned(
              left: 5.0,
              top: 90.0,
              child: Text(
                '商家登录',
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
                    autovalidate: true, // 自动校验
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
                                      Navigator.pushNamed(context, 'sRegister');
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
                                              prefs.setInt(
                                                  "supplierId", res["id"]);
                                              prefs.setString("SaccessToken",
                                                  res["accessToken"]);
                                              prefs.setString("SrefreshToken",
                                                  res["refreshToken"]);
                                              // 关闭键盘
                                              FocusScope.of(context)
                                                  .requestFocus(FocusNode());
                                              // 注册商家全局信息
                                              supplier.login(
                                                  id: res["id"],
                                                  username: res["username"],
                                                  imgCover: res["imgCover"],
                                                  phone: res["phone"]);
                                              // 清空表单
                                              reset();
                                              // 跳转路由
                                              supplier.connect();
                                              // 发送socket消息，商家上线
                                              // supplierLogin(supplier.socket,
                                              //     supplier.supplierInfo);
                                              Navigator.pushReplacementNamed(
                                                  context, 'supplierCenter',
                                                  arguments: {"id": res["id"]});
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
