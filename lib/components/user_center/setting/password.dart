import 'package:flutter/material.dart';
import 'package:commerce_shop_flutter/components/common/top_title.dart';
import 'package:provider/provider.dart';
import 'package:commerce_shop_flutter/provider/userData.dart';
import 'package:commerce_shop_flutter/config/service_method.dart';

class Password extends StatefulWidget {
  @override
  _PasswordState createState() => _PasswordState();
}

class _PasswordState extends State<Password> {
  GlobalKey _formKey = new GlobalKey();
  TextEditingController _pass1Controller = new TextEditingController();
  TextEditingController _pass2Controller = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserData>(context);
    return Scaffold(
      body: Container(
          // color: Color.fromRGBO(240, 237, 237, 1),
          child: Column(
        children: <Widget>[
          TopTitle(
            title: "修改密码",
            showArrow: true,
          ),
          Form(
            key: _formKey,
            // autovalidate: true,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // 校验旧密码
                  TextFormField(
                    controller: _pass1Controller,
                    decoration: InputDecoration(
                        labelText: "旧密码", icon: Icon(Icons.lock)),
                    validator: (v) {
                      return v.trim().length > 0 ? null : "旧密码不能为空";
                    },
                  ),
                  // 输入新密码
                  TextFormField(
                    controller: _pass2Controller,
                    decoration: InputDecoration(
                        labelText: "新密码", icon: Icon(Icons.lock)),
                    validator: (v) {
                      return v.trim().length > 0 ? null : "新密码不能为空";
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  RaisedButton(
                    child: Text("确定修改"),
                    onPressed: () async {
                      if ((_formKey.currentState as FormState).validate()) {
                        // 校验通过
                        var data = await getData("changePass", formdata: {
                          "id": user.userInfo.id,
                          "oldPass": _pass1Controller.text,
                          "newPass": _pass2Controller.text
                        });
                        if (data["errorCode"] == 0) {
                          (_formKey.currentState as FormState).reset();
                          FocusScope.of(context).requestFocus(FocusNode());
                          // 将用户信息注册到全局上
                          print("修改成功");
                        } else {
                          print(data["msg"]);
                        }
                      }
                    },
                  )
                ],
              ),
            ),
          )
        ],
      )),
    );
  }
}
