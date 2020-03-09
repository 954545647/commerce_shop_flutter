import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:commerce_shop_flutter/components/common/top_title.dart';
// import 'package:socket_io/socket_io.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:convert';
import 'package:provider/provider.dart';
import "package:commerce_shop_flutter/config/global.dart";

class Service extends StatefulWidget {
  Service({Key key, this.detail}) : super(key: key);
  final detail;

  @override
  _ServiceState createState() => new _ServiceState();
}

class _ServiceState extends State<Service> with SingleTickerProviderStateMixin {
  var fsNode1 = new FocusNode();
  var _textInputController = new TextEditingController();
  List talkList = []; //   谈话内容
  IO.Socket mysocket;
  @override
  void initState() {
    super.initState();
    _initSocket();
  }

  Future<void> _initSocket() async {
    await Future.delayed(Duration(microseconds: 300), () async {
      mysocket = Provider.of<MySocketIO>(context).mySocket;
      mysocket.on("replayFromService", (data) {
        createLi(data);
        setState(() {});
      });
    });
  }

  // 发送消息
  sendMessage(val) {
    val = {"content": val, "user": "xxx"};
    mysocket.emit("chatToService", val);
    createLi(val);
  }

  // 显示消息
  createLi(val) {
    talkList.add({
      "content": val["content"],
      "user": val["user"],
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: new Container(
            color: Colors.white,
            width: MediaQuery.of(context).size.width,
            child: Stack(
              children: <Widget>[
                TopTitle(title: "客服中心", showArrow: true),
                new Container(
                  decoration: BoxDecoration(border: Border.all(width: 1)),
                  margin: EdgeInsets.fromLTRB(0, 75, 0, 50),
                  child: talkWidgetList(),
                ),
                new Positioned(
                  bottom: 0,
                  left: 0,
                  width: MediaQuery.of(context).size.width,
                  child: Container(
                      color: Color(0xFFebebf3),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          new Container(
                            padding: new EdgeInsets.symmetric(horizontal: 10.0),
                            width: MediaQuery.of(context).size.width - 80.0,
                            child: new TextField(
                              focusNode: fsNode1,
                              controller: _textInputController,
                              decoration: new InputDecoration(
                                  border: InputBorder.none,
                                  hintText: '输入你的信息...',
                                  hintStyle:
                                      new TextStyle(color: Color(0xFF7c7c7e))),
                              onSubmitted: (val) {
                                if (val == null) {
                                  return;
                                }
                                sendMessage(val);
                                _textInputController.clear();
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
                              _textInputController.clear();
                            },
                            child: new Container(
                              decoration:
                                  BoxDecoration(border: Border.all(width: 1)),
                              padding:
                                  new EdgeInsets.symmetric(horizontal: 10.0),
                              child: Text("发送"),
                            ),
                          )
                        ],
                      )),
                )
              ],
            )),
      ),
    );
  }

  Widget talkWidgetList() {
    return Container(
      child: ListView(
          children: talkList.map((item) {
        return chatItem(item);
      }).toList()),
    );
  }

  Widget chatItem(value) {
    return Container(
      alignment:
          value["user"] == "客服" ? Alignment.centerLeft : Alignment.centerRight,
      child: Text(value["content"].toString()),
    );
  }
}
