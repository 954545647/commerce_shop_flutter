// 商家的Provider数据
import 'package:flutter/foundation.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class SupplierData with ChangeNotifier {
  bool _isLogin = false;
  var _supplierInfo;

  get isLogin => _isLogin;
  get supplierInfo => _supplierInfo;

// 登录
  login({id}) {
    _isLogin = true;
    _supplierInfo = new User(
      id: id,
    );
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

class User {
  int id; // 用户id
  // 标准写法
  User({
    int id,
  }) {
    this.id = id;
  }
}
