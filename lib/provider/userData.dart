// 用户的Provider数据
import 'package:flutter/foundation.dart';

class UserData with ChangeNotifier {
  bool _isLogin = false;
  var _userInfo;

  get isLogin => _isLogin;
  get userInfo => _userInfo;

// 登录
  login({id, username, phone}) {
    _isLogin = true;
    _userInfo = new User(id: id, username: username, phone: phone);
    notifyListeners();
  }

// 添加地址信息
  addAdress(id, address) {
    if (id == _userInfo.id) {
      _userInfo.address = address;
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
  String address;
  // 标准写法
  User({int id, String username, String phone, String address = ""}) {
    this.id = id;
    this.username = username;
    this.phone = phone;
    this.address = address;
  }
}
