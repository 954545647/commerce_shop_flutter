import 'package:flutter/foundation.dart';

class CartData with ChangeNotifier {
  List<Cart> _cartInfo = [];

  get cartInfo => _cartInfo;
  get cartLen => _cartInfo.length;

// 判断购物车是否已经保存该商品信息
  has(userId, goodId) {
    bool res = false;
    _cartInfo.forEach((item) {
      if (item.goodId == goodId && item.userId == userId) {
        res = true;
      }
    });
    return res;
  }

  // 购物车新增商品
  add(userId, cartId, goodId, goodName, supplierId, count, price, expressCost) {
    _cartInfo.add(new Cart(userId, cartId, goodId, goodName, supplierId, count,
        price, expressCost));
  }

// 清空
  clear() {
    _cartInfo = [];
  }

// 获取当前用户购物车中所有商品的商家Id
  getSupplierById(userId) {
    List<int> supplierIds = [];
    _cartInfo.forEach((item) {
      if (item.userId == userId) {
        supplierIds.add(item.supplierId);
      }
    });
    return supplierIds;
  }

  // 移除商品
  remove(userId, goodId) {
    int index;
    // 先找出当前的购物车是否有该商品
    _cartInfo.forEach((item) {
      if (item.userId == userId && item.goodId == goodId) {
        index = _cartInfo.indexOf(item);
      }
    });
    if (index != null) {
      _cartInfo.removeAt(index);
    }
  }
}

class Cart {
  int userId; // 用户id
  int cartId; // 购物车id
  int goodId; // 商品id
  int supplierId; // 供应商id
  String goodName; // 商品名字
  int count; // 商品件数
  String price; // 商品件数
  String expressCost; // 商品件数

  Cart(int userId, int cartId, int goodId, String goodName, int supplierId,
      int count, String price, String expressCost) {
    this.userId = userId;
    this.cartId = cartId;
    this.goodId = goodId;
    this.goodName = goodName;
    this.supplierId = supplierId;
    this.count = count;
    this.expressCost = expressCost;
    this.price = price;
  }
}
