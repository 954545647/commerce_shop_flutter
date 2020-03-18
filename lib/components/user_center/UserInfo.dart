// 用户信息（头像+名字）
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:commerce_shop_flutter/provider/userData.dart';
import 'package:commerce_shop_flutter/config/config.dart';

class UserInfo extends StatefulWidget {
  @override
  _UserInfoState createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  @override
  Widget build(BuildContext context) {
    return userInfo();
  }

  Widget userInfo() {
    final user = Provider.of<UserData>(context);
    var userInfo = user.userInfo;
    bool isLogin = user.isLogin;
    return Container(
      child: Row(
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              isLogin
                  ? Row(
                      children: <Widget>[
                        ClipOval(
                          child: Image.network(
                            "${Config.apiHost}/${userInfo.imgCover}",
                            fit: BoxFit.cover,
                            width: 65,
                            height: 65,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          userInfo.username,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 22.0,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    )
                  : RaisedButton(
                      child: Text("点击登录"),
                      onPressed: () => Navigator.pushNamed(context, "login"),
                    ),
            ],
          ),
        ],
      ),
    );
  }
}
