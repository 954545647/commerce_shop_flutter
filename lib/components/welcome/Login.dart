import 'package:flutter/material.dart';
import './../../model/state.dart';
import './../../model/actions.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:commerce_shop_flutter/pages/index.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _unameController = new TextEditingController();
  TextEditingController _pwdController = new TextEditingController();
  GlobalKey _formKey = new GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
        child: Form(
            key: _formKey,
            // autovalidate: true,
            child: new StoreConnector(converter: (Store<AppState> store) {
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
                          return v.trim().length > 5 ? null : "密码不能少于6位";
                        }),
                    Padding(
                      padding: EdgeInsets.only(top: 28.0),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: RaisedButton(
                              padding: EdgeInsets.all(15.0),
                              child: Text('登录'),
                              onPressed: () {
                                if ((_formKey.currentState as FormState)
                                    .validate()) {
                                  store.dispatch(new LoginSuccessAction(
                                      userName: _unameController.text,
                                      password: _pwdController.text));
                                  Navigator.of(context).pushAndRemoveUntil(
                                      new MaterialPageRoute(
                                          builder: (context) =>
                                              new IndexPage()),
                                      (route) => route == null);
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            })),
      ),
    );
  }
}
