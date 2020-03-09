import 'package:socket_io_client/socket_io_client.dart' as IO;
import "package:commerce_shop_flutter/config/config.dart";

class MySocketIO {
  IO.Socket mySocket;
  MySocketIO(this.mySocket);
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
