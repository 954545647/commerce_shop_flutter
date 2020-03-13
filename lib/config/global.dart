import 'package:socket_io_client/socket_io_client.dart' as IO;

class MySocketIO {
  IO.Socket socket;
  MySocketIO(this.socket);
}

class MessageInfo {
  int fromId; // 发信息人Id
  int toId = 0; // 收信息人Id
  String content = ""; // 信息内容
  String fromName;
  String toName;
  int type = 0; // 是哪方发送

  MessageInfo(
      {this.fromId,
      this.toId,
      this.content,
      this.fromName,
      this.toName,
      this.type});

  MessageInfo.fromJson(Map json) {
    toName = json["toName"];
    fromName = json["fromName"];
    fromId = json['fromId'];
    toId = json['toId'];
    content = json['content'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() => {
        'fromId': fromId,
        'toId': toId,
        'content': content,
        'toName': toName,
        'fromName': fromName,
        'type': type,
      };
}

class Global {
  //初始化全局信息，会在APP启动时执行
  // static Future init() async {
  //   IO.Socket mysocket = IO.io(BASEURL, <String, dynamic>{
  //     "transports": ['websocket'],
  //   });
  //   return {"socketIO": mysocket};
  // }
}
