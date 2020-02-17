// 用户的Provider数据
import 'package:flutter/foundation.dart';

class UserData with ChangeNotifier {
  bool _isLogin = false;
  var _userInfo;

  get isLogin => _isLogin;
  get userInfo => _userInfo;

// 登录
  login(id, username, phone) {
    _isLogin = true;
    _userInfo = new User(id, username, phone);
    notifyListeners();
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

  // 标准写法
  User(int id, String username, String phone) {
    this.id = id;
    this.username = username;
    this.phone = phone;
  }
}
