// 联系商家
import 'package:flutter/material.dart';
import 'package:commerce_shop_flutter/components/common/top_title.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:provider/provider.dart';
import 'package:commerce_shop_flutter/provider/userData.dart';
import "package:commerce_shop_flutter/config/global.dart";
import 'package:commerce_shop_flutter/utils/dio.dart';
import 'package:commerce_shop_flutter/provider/supplierData.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:commerce_shop_flutter/config/config.dart';
import 'dart:async';

class ChatToSupplier extends StatefulWidget {
  @override
  _ChatToSupplierState createState() => _ChatToSupplierState();
}

class _ChatToSupplierState extends State<ChatToSupplier> {
  var fsNode1 = new FocusNode();
  ScrollController _controller =
      new ScrollController(initialScrollOffset: 200.0);
  var _textInputController = new TextEditingController();
  IO.Socket mysocket;
  SupplierData supplierData;
  UserData userData;
  List talkList = []; //   谈话内容
  bool typing = false; // 是否有输入内容
  @override
  void initState() {
    super.initState();
    _initSocket();
  }

  Future<void> _initSocket() async {
    await Future.delayed(Duration(microseconds: 300), () async {
      Map args = ModalRoute.of(context).settings.arguments;
      userData = Provider.of<UserData>(context);
      supplierData = Provider.of<SupplierData>(context);
      // 获取历史记录
      await getHistory();
      mysocket = userData.socket;
      // 告诉商家开始咨询服务(这里不能使用Provider，因为商家可能未登录)
      mysocket.emit(
          "startForSupplier",
          new MessageInfo(
              fromId: userData.userInfo.id,
              fromName: userData.userInfo.username,
              toId: args["id"],
              toName: args["username"],
              type: 0));
      // 监听商家返回消息
      mysocket.on("replayFromSupplier", (data) {
        createLi(data);
        setState(() {});
      });
    });
  }

  // 获取历史消息
  Future getHistory() async {
    Map args = ModalRoute.of(context).settings.arguments;
    var data = await DioUtils.getInstance().post("supplierHistory",
        data: {"toId": args["id"], "fromId": userData.userInfo.id});
    if (data != null && data["data"] != null) {
      talkList = data["data"].reversed.toList();
    }
    setState(() {});
  }

  // 发送消息
  sendMessage(val) {
    Map args = ModalRoute.of(context).settings.arguments;
    val = {
      "content": val,
      "fromName": userData.userInfo.username,
      "fromId": userData.userInfo.id,
      "toId": args["id"],
      "toName": args["username"],
      "type": 0
    };
    mysocket.emit("chatToSupplier", val);
    createLi(val);
    setState(() {});
  }

  // 顾客离开
  clientExit() {
    mysocket.emit("nochatToSupplier", {"id": userData.userInfo.id});
  }

  // 显示消息
  createLi(val) {
    talkList.add({
      "content": val["content"],
      "fromName": val["fromName"],
      "type": val["type"]
    });
  }

  @override
  void dispose() {
    if (mysocket != null) {
      mysocket.off("replayFromSupplier");
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Timer(Duration(microseconds: 0),
        () => _controller.jumpTo(_controller.position.maxScrollExtent));
    Map args = ModalRoute.of(context).settings.arguments;
    String name = args["username"];
    String imgCover = args["imgCover"];
    return Scaffold(
      body: Container(
        color: Color.fromRGBO(240, 240, 240, 1),
        child: Column(
          children: <Widget>[
            TopTitle(
              title: name,
              showArrow: true,
              shouldExecute: true,
              method: clientExit,
            ),
            Expanded(
              child: ListView.builder(
                controller: _controller,
                itemCount: talkList.length,
                itemBuilder: (BuildContext context, int index) {
                  int type = talkList[index]["type"];
                  if (type == 1) {
                    return fromService(talkList[index], imgCover);
                  } else {
                    return chatItem(talkList[index]);
                  }
                },
              ),
            ),
            Container(
                alignment: Alignment.center,
                height: ScreenUtil().setHeight(100),
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                // margin: EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                    // borderRadius: BorderRadius.circular(15),
                    color: Colors.white),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    new Container(
                      decoration: BoxDecoration(
                          color: Color.fromRGBO(251, 249, 250, 1),
                          borderRadius: BorderRadius.circular(15)),
                      padding: new EdgeInsets.symmetric(horizontal: 10.0),
                      height: ScreenUtil().setHeight(80),
                      width: ScreenUtil().setWidth(480),
                      child: new TextField(
                        focusNode: fsNode1,
                        controller: _textInputController,
                        onChanged: (String val) {
                          typing = val.length > 0;
                          setState(() {});
                        },
                        decoration: new InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 10.0),
                            border: InputBorder.none,
                            hintText: '输入你的信息...',
                            hintStyle: new TextStyle(color: Color(0xFF7c7c7e))),
                        onSubmitted: (val) {
                          if (val == null || val.length == 0 || val == "") {
                            return;
                          }
                          sendMessage(val);
                          _textInputController.clear();
                          typing = false;
                        },
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        String val = _textInputController.text;
                        if (val == "" || val == null) {
                          return;
                        }
                        sendMessage(val);
                        typing = false;
                        _textInputController.clear();
                      },
                      child: new Container(
                        alignment: Alignment.center,
                        height: ScreenUtil().setHeight(80),
                        width: ScreenUtil().setWidth(120),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18.0),
                            color: typing
                                ? Color.fromRGBO(247, 128, 82, 1)
                                : Color.fromRGBO(251, 249, 250, 1)),
                        child: Text(
                          "发送",
                          style: TextStyle(
                              color: typing ? Colors.white : Color(0xFF7c7c7e)),
                        ),
                      ),
                    )
                  ],
                ))
          ],
        ),
      ),
    );
  }

  Widget chatItem(data) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      height: 50,
      width: MediaQuery.of(context).size.width,
      child: Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
        Container(
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(15)),
          alignment: Alignment.center,
          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          height: 50,
          child: Text(data["content"].toString()),
        ),
        SizedBox(
          width: 10,
        ),
        Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                image: DecorationImage(
                    image: NetworkImage(
                        "${Config.apiHost}${userData.userInfo.imgCover}"),
                    fit: BoxFit.cover)))
      ]),
    );
  }

  Widget fromService(data, imgCover) {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      margin: EdgeInsets.only(bottom: 10),
      height: 50,
      width: MediaQuery.of(context).size.width,
      child: Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
        Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                image: DecorationImage(
                    image: NetworkImage("${Config.apiHost}$imgCover"),
                    fit: BoxFit.cover))),
        SizedBox(
          width: 10,
        ),
        Container(
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(15)),
          alignment: Alignment.center,
          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          height: 50,
          child: Text(data["content"].toString()),
        )
      ]),
    );
  }
}
