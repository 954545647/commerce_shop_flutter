// 商家的Provider数据
import 'package:flutter/foundation.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import "package:commerce_shop_flutter/config/config.dart";

class SupplierData with ChangeNotifier {
  bool _isLogin = false;
  var _supplierInfo;
  IO.Socket _socket; // socket实例

  get isLogin => _isLogin;
  get supplierInfo => _supplierInfo;
  get socket => _socket;

  // 登录
  login({int id, String username, String phone, String imgCover}) {
    _isLogin = true;
    _supplierInfo = new Supplier(
        id: id, username: username, phone: phone, imgCover: imgCover);
    notifyListeners();
  }

  // 退出
  logout() async {
    _isLogin = false;
    print("退出登录啦！");
    _supplierInfo = {};
    notifyListeners();
  }

  // 连接
  connect() {
    print("socket连接成功");
    IO.Socket mysocket = IO.io(BASEURL, <String, dynamic>{
      "transports": ['websocket'],
    });
    _socket = mysocket;
  }

  // 断开连接
  disconnect() {
    print("socket断开连接");
    _socket.close();
  }
}

class Supplier {
  int id; // 用户id
  String username;
  String phone;
  String imgCover;
  Supplier({int id, String username, String phone, String imgCover}) {
    this.id = id;
    this.username = username;
    this.phone = phone;
    this.imgCover = imgCover;
  }
}
