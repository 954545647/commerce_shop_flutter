import 'package:flutter/material.dart';
import 'package:commerce_shop_flutter/components/common/top_title.dart';
import 'package:provider/provider.dart';
import 'package:commerce_shop_flutter/provider/userData.dart';
import 'package:commerce_shop_flutter/provider/socketData.dart';

class Setting extends StatefulWidget {
  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  @override
  Widget build(BuildContext context) {
    final socket = Provider.of<SocketData>(context);

    final user = Provider.of<UserData>(context);
    List listData = [
      {'jumpRoute': 'password', 'title': '修改密码'},
      {'jumpRoute': 'photo', 'title': '更换头像'},
      {'jumpRoute': 'password', 'title': '常见问题'},
      {'jumpRoute': 'password', 'title': '关于应用'},
    ];
    return Scaffold(
      body: Container(
          color: Color.fromRGBO(240, 237, 237, 1),
          child: Column(
            children: <Widget>[
              TopTitle(
                title: "设置",
                top: 20.0,
                showArrow: true,
              ),
              ListView.builder(
                itemCount: listData.length,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    child: Container(
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(
                          border: Border(
                              bottom:
                                  BorderSide(width: 1, color: Colors.black12)),
                          color: Colors.white),
                      child: Text(listData[index]["title"]),
                      height: 50.0,
                      padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                    ),
                    onTap: () {
                      Navigator.pushNamed(
                          context, listData[index]["jumpRoute"]);
                    },
                  );
                },
              ),
              SizedBox(
                height: 10,
              ),
              GestureDetector(
                child: Container(
                  color: Colors.white,
                  height: 50.0,
                  alignment: Alignment.center,
                  child: Text("退出登录"),
                ),
                onTap: () {
                  // 先弹出框提示警告
                  // 断开socket连接
                  socket.disconnect();
                  user.logout();
                  Navigator.pushNamed(context, "index");
                },
              )
            ],
          )),
    );
  }
}
