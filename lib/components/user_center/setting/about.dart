import 'package:flutter/material.dart';
import 'package:commerce_shop_flutter/components/common/top_title.dart';

class About extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          TopTitle(
            title: "关于应用",
            showArrow: true,
          ),
          Container(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
            child: Text(
              "前端使用flutter搭建整体项目结构,当前项目版本是：Flutter 1.12.13+hotfix.5.",
              style: TextStyle(fontSize: 20),
            ),
          ),
          Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                usePlug("flutter_screenutil", "屏幕适配"),
                usePlug("provider", "全局状态管理"),
                usePlug("shared_preferences", "本地存储"),
                usePlug("image_picker", "图片上传"),
                usePlug("socket_io_client", "socket通信"),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(20, 20, 20, 10),
            child: Text(
              "后端使用node搭建整体项目结构,使用koa框架搭配mysql数据库.",
              style: TextStyle(fontSize: 20),
            ),
          ),
          Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                usePlug("jsonwebtoken", "token校验"),
                usePlug("koa-static", "静态资源服务器"),
                usePlug("sequelize", "mysql的ORM框架"),
                usePlug("socket.io", "socket通信"),
                usePlug("validator", "参数校验"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget usePlug(name, detail) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            name,
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(width: 15),
          Text(detail),
        ],
      ),
    );
  }
}
