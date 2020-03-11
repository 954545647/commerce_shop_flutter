import 'package:socket_io_client/socket_io_client.dart' as IO;
import "package:commerce_shop_flutter/config/config.dart";

class MySocketIO {
  IO.Socket socket;
  MySocketIO(this.socket);
}

class MessageInfo {
  int fromId; // 发信息人Id
  int toId = 0; // 收信息人Id
  String content = ""; // 信息内容
  String username;

  MessageInfo({this.fromId, this.toId, this.content, this.username});

  MessageInfo.fromJson(Map json) {
    fromId = json['fromId'];
    toId = json['toId'];
    content = json['content'];
    username = json['username'];
  }

  Map<String, dynamic> toJson() => {
        'fromId': fromId,
        'toId': toId,
        'content': content,
        'username': username,
      };
}

class Global {
  //初始化全局信息，会在APP启动时执行
  static Future init() async {
    IO.Socket mysocket = IO.io(BASEURL, <String, dynamic>{
      "transports": ['websocket'],
    });
    return {"socketIO": mysocket};
  }
}
