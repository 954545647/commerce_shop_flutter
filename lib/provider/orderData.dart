// 订单全局数据
import 'package:flutter/foundation.dart';

class OrderData with ChangeNotifier {}

class Order {
  int userId;
  int orderId;
  order(int userId, int orderId) {
    this.userId = userId;
    this.orderId = orderId;
  }
}
