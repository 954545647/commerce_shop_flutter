import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter/foundation.dart';
import "package:commerce_shop_flutter/config/config.dart";

class SocketData with ChangeNotifier {
  IO.Socket _socket;
  get socket => _socket;

  connect() {
    if (_socket == null) {
      IO.Socket mysocket = IO.io(BASEURL, <String, dynamic>{
        "transports": ['websocket'],
      });
      _socket = mysocket;
    } else {
      _socket.connect();
    }
    _socket.on("connect", (_) {
      print("连接成功");
    });
  }

  disconnect() {
    _socket.disconnect();
    print("socket断开连接");
  }
}

class MySocketIO {
  IO.Socket socket;
  MySocketIO(this.socket) {
    this.socket = socket;
  }
}
