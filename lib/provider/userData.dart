import 'package:flutter/foundation.dart';

class UserData with ChangeNotifier {
  bool _isLogin = false;
  var _userInfo;

  get isLogin => _isLogin;
  get userInfo => _userInfo;

  login(id, username, phone) {
    _isLogin = true;
    _userInfo = new User(id, username, phone);
    notifyListeners();
  }

  logout() {
    _isLogin = false;
    notifyListeners();
  }
}

class User {
  int id;
  String username;
  String phone;

  // 标准写法
  User(int id, String username, String phone) {
    this.id = id;
    this.username = username;
    this.phone = phone;
  }
}
