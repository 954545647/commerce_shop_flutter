import 'package:flutter/foundation.dart';

class CartData with ChangeNotifier {
  List<Cart> _cartInfo = [new Cart(1, "rx", 1, "1", "2")];

  get cartInfo => _cartInfo;
  get cartLen => _cartInfo.length;

  // 购物车新增商品
  add(id, goodName, count, price, expressCost) {
    // 判断当前的商品id是否已经在购物车了，如果在就直接增加数量不加购物车长度
    _cartInfo.add(new Cart(id, goodName, count, price, expressCost));
  }

  // 移除商品
  remove(id) {
    int index;
    // 先找出当前的购物车是否有该商品
    _cartInfo.forEach((item) {
      if (item.id == id) {
        index = _cartInfo.indexOf(item);
      }
    });
    if (index != null) {
      _cartInfo.removeAt(index);
    }
  }
}

class Cart {
  int id; // 商品id
  String goodName; // 商品名字
  int count; // 商品数量
  String price; // 商品单价
  String expressCost; // 商品运费

  Cart(int id, String goodName, int count, String price, String expressCost) {
    this.id = id;
    this.goodName = goodName;
    this.count = count;
    this.price = price;
    this.expressCost = expressCost;
  }
}
