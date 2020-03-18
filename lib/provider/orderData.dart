// 订单全局数据
import 'package:flutter/foundation.dart';

class OrderData with ChangeNotifier {
  var _orderInfo;

  get orderInfo => _orderInfo;

  addAddress(int userId, String address) {
    _orderInfo = new Order(userId, address);
  }
}

class Order {
  int userId;
  String address;
  Order(int userId, String address) {
    this.userId = userId;
    this.address = address;
  }
}
