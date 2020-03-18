// 商家 -> 详细聊天
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:commerce_shop_flutter/components/common/top_title.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import "package:commerce_shop_flutter/utils/dio.dart";
import 'package:provider/provider.dart';
import 'package:commerce_shop_flutter/provider/supplierData.dart';
import "package:commerce_shop_flutter/config/global.dart";
import 'dart:async';
import 'package:commerce_shop_flutter/config/config.dart';

class InformationDetail extends StatefulWidget {
  @override
  _InformationDetailState createState() => new _InformationDetailState();
}

class _InformationDetailState extends State<InformationDetail> {
  var fsNode1 = new FocusNode();
  ScrollController _controller =
      new ScrollController(initialScrollOffset: 200.0);
  var _textInputController = new TextEditingController();
  List talkList = []; //   谈话内容
  IO.Socket mysocket;
  SupplierData supplierData;
  bool typing = false; // 是否有输入内容
  @override
  void initState() {
    super.initState();
    _initSocket();
  }

  // 初始化连接socket
  Future<void> _initSocket() async {
    await Future.delayed(Duration(microseconds: 300), () async {
      Map args = ModalRoute.of(context).settings.arguments;
      supplierData = Provider.of<SupplierData>(context);
      mysocket = supplierData.socket;
      // 获取历史记录
      await getHistory();
      // 告诉顾客商家开始客服服务了
      mysocket.emit(
          "supplierLogin",
          new MessageInfo(
              fromId: supplierData.supplierInfo.id,
              fromName: supplierData.supplierInfo.username,
              toId: args["userInfo"]["id"],
              toName: args["userInfo"]["username"],
              type: 1));
      // 监听顾客回复
      mysocket.on("supplier", (data) {
        createLi(data);
        setState(() {});
      });
    });
  }

  // 获取历史消息
  Future getHistory() async {
    Map args = ModalRoute.of(context).settings.arguments;
    var data = await DioUtil.getInstance(context).post("supplierHistory",
        data: {
          "toId": args["userInfo"]["id"],
          "fromId": supplierData.supplierInfo.id
        });
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
      "fromName": supplierData.supplierInfo.username,
      "fromId": supplierData.supplierInfo.id,
      "toId": args["userInfo"]["id"],
      "toName": args["userInfo"]["username"],
      "type": 1
    };
    mysocket.emit("SreplayToClient", val);
    createLi(val);
    setState(() {});
  }

  // 商家离开
  supplierExit() {
    mysocket.emit("SnosreplayToClient", {"id": supplierData.supplierInfo.id});
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
      mysocket.off("supplier");
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Timer(Duration(microseconds: 0),
        () => _controller.jumpTo(_controller.position.maxScrollExtent));
    return new Scaffold(
      backgroundColor: Color.fromRGBO(242, 242, 242, 1),
      body: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: Column(
          children: <Widget>[
            TopTitle(
              title: "聊天",
              showArrow: true,
              ifRefresh: true,
              shouldExecute: true,
              method: supplierExit,
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: ListView.builder(
                controller: _controller,
                itemCount: talkList.length,
                itemBuilder: (BuildContext context, int index) {
                  int type = talkList[index]["type"];
                  // 消息中心，商家是聊天方
                  if (type == 1) {
                    return chatItem(talkList[index]);
                  } else {
                    return fromService(talkList[index]);
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
                        "${Config.apiHost}/${supplierData.supplierInfo.imgCover}"),
                    fit: BoxFit.cover)))
      ]),
    );
  }

  Widget fromService(data) {
    Map args = ModalRoute.of(context).settings.arguments;
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
                    image: NetworkImage(
                        "${Config.apiHost}/${args["userInfo"]["imgCover"]}"),
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
