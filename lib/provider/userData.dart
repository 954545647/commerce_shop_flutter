// 用户的Provider数据
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import "package:commerce_shop_flutter/config/config.dart";

class UserData with ChangeNotifier {
  bool _isLogin = false;
  var _userInfo;
  IO.Socket _socket; // socket实例

  get isLogin => _isLogin;
  get userInfo => _userInfo;
  get socket => _socket;

// 登录
  login({id, username, phone, address, unpayOrder, imgCover}) {
    _isLogin = true;
    _userInfo = new User(
        id: id,
        username: username,
        phone: phone,
        address: address,
        imgCover: imgCover,
        unpayOrder: unpayOrder);
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

// 添加地址信息
  addAdress(int id, String address) {
    if (id == _userInfo.id) {
      _userInfo.address = address;
    }
  }

// 添加未支付订单订单号
  addUnpayOrder(int id, int order) {
    if (id == _userInfo.id) {
      _userInfo.unpayOrder.add(order);
    }
  }

  // 添加未支付订单订单号
  deleteUnpayOrder(int id, int index) {
    if (id == _userInfo.id) {
      _userInfo.unpayOrder.removeAt(index);
    }
  }

  // 更改头像
  updateCover(int id, String cover) {
    if (id == _userInfo.id) {
      _userInfo.imgCover = cover;
    }
  }

// 退出
  logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    _isLogin = false;
    _userInfo = {};
    notifyListeners();
  }
}

class User {
  int id; // 用户id
  String username; // 用户名字
  String phone; // 用户电话
  String address; // 用户地址
  List unpayOrder; // 未支付地址
  String imgCover; // 头像
  User(
      {int id,
      String username,
      String phone,
      String address = "",
      String imgCover = "",
      List unpayOrder}) {
    this.id = id;
    this.username = username;
    this.phone = phone;
    this.address = address;
    this.unpayOrder = unpayOrder;
    this.imgCover = imgCover;
  }
}
