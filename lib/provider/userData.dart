import 'package:flutter/foundation.dart';

class UserData with ChangeNotifier {
  bool _isLogin = false;
  var _userInfo;

  get isLogin => _isLogin;
  get userInfo => _userInfo;

  login(username, phone) {
    _isLogin = true;
    _userInfo = new User(username, phone);
    notifyListeners();
  }

  logout() {
    _isLogin = false;
    notifyListeners();
  }
}

class User {
  String username;
  String phone;

  // 标准写法
  User(String username, String phone) {
    this.username = username;
    this.phone = phone;
  }
}
