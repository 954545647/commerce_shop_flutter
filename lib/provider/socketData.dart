import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter/foundation.dart';
import "package:commerce_shop_flutter/config/config.dart";

class SocketData with ChangeNotifier {
  IO.Socket _socket;
  get socket => _socket;

  connect() {
    print("socket连接成功");
    IO.Socket mysocket = IO.io(BASEURL, <String, dynamic>{
      "transports": ['websocket'],
    });
    _socket = mysocket;
  }

  disconnect() {
    print("socket断开连接");
    _socket.close();
  }
}

class MySocketIO {
  IO.Socket socket;
  MySocketIO(this.socket) {
    this.socket = socket;
  }
}
