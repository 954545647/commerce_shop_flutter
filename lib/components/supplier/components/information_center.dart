// 客服中心
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:commerce_shop_flutter/components/common/top_title.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import "package:commerce_shop_flutter/utils/dio.dart";
import 'package:provider/provider.dart';
import 'package:commerce_shop_flutter/provider/supplierData.dart';
// import "package:commerce_shop_flutter/config/global.dart";
import 'dart:async';
import 'package:commerce_shop_flutter/config/config.dart';
import "package:commerce_shop_flutter/utils/utils.dart";

class InformationCenter extends StatefulWidget {
  @override
  _InformationCenterState createState() => new _InformationCenterState();
}

class _InformationCenterState extends State<InformationCenter> {
  IO.Socket mysocket;
  SupplierData supplierData;
  var message;
  @override
  void initState() {
    super.initState();
    _initSocket();
  }

  // 初始化连接socket
  Future<void> _initSocket() async {
    await Future.delayed(Duration(microseconds: 300), () async {
      supplierData = Provider.of<SupplierData>(context);
      mysocket = supplierData.socket;
      // 监听客服回复
      // mysocket.on("replayFromService", (data) {
      //   setState(() {});
      // });
      await getHistory();
    });
  }

  // 获取历史记录
  Future<void> getHistory() async {
    var data = await DioUtils.getInstance()
        .post("SsupplierMessage", data: {"id": supplierData.supplierInfo.id});
    setState(() {
      message = data["data"];
    });
  }

  // 获取历史消息

  @override
  void dispose() {
    if (mysocket != null) {
      // mysocket.off("replayFromService");
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.white,
      body: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: Container(
          child: ListView(
            children: <Widget>[
              TopTitle(title: "消息中心", showArrow: true),
              userList(),
            ],
          ),
        ),
      ),
    );
  }

  userList() {
    if (message != null && message.values.length > 0) {
      List<Widget> list = [];
      for (int i = 0; i < message.values.length; i++) {
        list.add(userItem(message[message.keys.toList()[i]]));
      }
      return Column(
        children: list,
      );
    } else {
      return Container(
        alignment: Alignment.center,
        height: 500,
        child: Text("暂无消息"),
      );
    }
  }

  Widget userItem(data) {
    var userInfo = data["userInfo"];
    List historyInfo = data["historyInfo"];
    String lastMess = historyInfo[0]["content"];
    String lassMessTime = historyInfo[0]["createdAt"];
    return GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, "informationDetail", arguments: data);
        },
        child: Container(
          height: ScreenUtil().setHeight(120),
          child: Row(
            children: <Widget>[
              Container(
                width: ScreenUtil().setWidth(120),
                height: ScreenUtil().setHeight(120),
                padding: EdgeInsets.all(8),
                child: Image.network(
                  "${Config.apiHost}${userInfo["imgCover"]}",
                  width: ScreenUtil().setWidth(100),
                  height: ScreenUtil().setHeight(100),
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(
                    ScreenUtil().setWidth(10), 0, ScreenUtil().setWidth(10), 0),
                width: MediaQuery.of(context).size.width -
                    ScreenUtil().setHeight(140),
                decoration: BoxDecoration(
                    border: Border(
                  bottom: BorderSide(width: 1, color: Colors.black12),
                )),
                alignment: Alignment.bottomLeft,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          userInfo["username"],
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        Text(
                          getMessTime(lassMessTime),
                          style: TextStyle(color: Colors.black12, fontSize: 12),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          lastMess,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: Colors.black26, fontSize: 16),
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
