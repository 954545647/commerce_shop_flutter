// 用户的Provider数据
import 'package:flutter/foundation.dart';

class UserData with ChangeNotifier {
  bool _isLogin = false;
  var _userInfo;

  get isLogin => _isLogin;
  get userInfo => _userInfo;

// 登录
  login({id, username, phone, address, unpayOrder}) {
    _isLogin = true;
    _userInfo = new User(
        id: id,
        username: username,
        phone: phone,
        address: address,
        unpayOrder: unpayOrder);
    notifyListeners();
  }

// 添加地址信息
  addAdress(id, address) {
    if (id == _userInfo.id) {
      _userInfo.address = address;
    }
  }

// 添加未支付订单订单号
  addUnpayOrder(id, order) {
    if (id == _userInfo.id) {
      _userInfo.unpayOrder.add(order);
    }
  }

  // 添加未支付订单订单号
  deleteUnpayOrder(id, index) {
    if (id == _userInfo.id) {
      _userInfo.unpayOrder.removeAt(index);
    }
  }

// 退出
  logout() {
    _isLogin = false;
    notifyListeners();
  }
}

class User {
  int id; // 用户id
  String username; // 用户名字
  String phone; // 用户电话
  String address; // 用户地址
  List unpayOrder; // 未支付地址
  // 标准写法
  User(
      {int id,
      String username,
      String phone,
      String address = "",
      List unpayOrder}) {
    this.id = id;
    this.username = username;
    this.phone = phone;
    this.address = address;
    this.unpayOrder = unpayOrder;
  }
}
