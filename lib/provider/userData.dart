// 用户的Provider数据
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserData with ChangeNotifier {
  bool _isLogin = false;
  var _userInfo;

  get isLogin => _isLogin;
  get userInfo => _userInfo;

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
