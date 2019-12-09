import 'package:flutter/material.dart';
import 'package:commerce_shop_flutter/model/state.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:commerce_shop_flutter/pages/index.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:commerce_shop_flutter/model/actions.dart';

class Login extends StatefulWidget {
  final int counter;
  final String userName;
  final bool isLogin;
  Login({this.counter, this.userName, this.isLogin});
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _unameController = new TextEditingController();
  TextEditingController _pwdController = new TextEditingController();
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
                      Navigator.pushNamed(context, '/welcome');
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
                    key: _formKey,
                    // autovalidate: true,
                    child:
                        new StoreConnector(converter: (Store<AppState> store) {
                      return store;
                    }, builder: (BuildContext context, Store<AppState> store) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            TextFormField(
                              controller: _unameController,
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
                                obscureText: true,
                                //校验密码
                                validator: (v) {
                                  return v.trim().length > 5
                                      ? null
                                      : "密码不能少于6位";
                                }),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Column(
                                  children: <Widget>[
                                    InkWell(
                                      child: Container(
                                        margin:
                                            EdgeInsets.fromLTRB(0, 30, 30, 0),
                                        child: Text(
                                          'Frogot your password?',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      onTap: () {},
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
                                      onTap: () {
//                                         if ((_formKey.currentState as FormState)
//                                             .validate()) {
//                                           store.dispatch(new LoginSuccessAction(
//                                               userName: _unameController.text,
//                                               password: _pwdController.text));
// ;
//                                         }
                                        Navigator.of(context)
                                            .pushAndRemoveUntil(
                                                new MaterialPageRoute(
                                                    builder: (context) =>
                                                        new IndexPage()),
                                                (route) => route == null);
                                      },
                                    )
                                  ],
                                ),
                              ],
                            )
                          ],
                        ),
                      );
                    })),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
