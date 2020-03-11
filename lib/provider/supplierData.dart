// 商家的Provider数据
import 'package:flutter/foundation.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class SupplierData with ChangeNotifier {
  bool _isLogin = false;
  var _supplierInfo;

  get isLogin => _isLogin;
  get supplierInfo => _supplierInfo;

// 登录
  login({id, username, phone}) {
    _isLogin = true;
    _supplierInfo = new Supplier(id: id, username: username, phone: phone);
    notifyListeners();
  }

// 退出
  logout() async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // prefs.clear();
    _isLogin = false;
    print("退出登录啦！");
    _supplierInfo = {};
    notifyListeners();
  }
}

class Supplier {
  int id; // 用户id
  String username;
  String phone;
  Supplier({int id, String username, String phone}) {
    this.id = id;
    this.username = username;
    this.phone = phone;
  }
}
