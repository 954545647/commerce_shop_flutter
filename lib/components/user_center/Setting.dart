import 'package:flutter/material.dart';
import 'package:commerce_shop_flutter/components/common/top_title.dart';
import 'package:provider/provider.dart';
import 'package:commerce_shop_flutter/provider/userData.dart';

class Setting extends StatefulWidget {
  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserData>(context);
    List settingList = ["修改密码", "常见问题", "关于应用"];
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
                itemCount: settingList.length,
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
                      child: Text(settingList[index]),
                      height: 50.0,
                      padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                    ),
                    onTap: () {
                      print(settingList[index]);
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
                  user.logout();
                  Navigator.pop(context);
                },
              )
            ],
          )),
    );
  }
}
