// 商品信息 Provider
import 'package:flutter/foundation.dart';

class GoodData with ChangeNotifier {
  List<Good> _goodLists = [];

  get goodLists => _goodLists;

// 判断是否已经保存该商品信息
  has(id) {
    bool res = false;
    _goodLists.forEach((item) {
      if (item.id == id) {
        res = true;
      }
    });
    return res;
  }

  // 新增商品信息
  add(id, goodName, stock, sales, expressCost, imgCover) {
    stock = int.parse(stock);
    sales = int.parse(sales);
    if (has(id)) {
      return;
    } else {
      _goodLists
          .add(new Good(id, goodName, stock, sales, expressCost, imgCover));
    }
  }

  getGoodById(id) {
    var result;
    if (has(id)) {
      _goodLists.forEach((item) {
        if (item.id == id) {
          result = item;
        }
      });
    } else {
      return null;
    }
    return result;
  }

  // 获取商品某一数据
  getStock(id) {
    var result;
    if (has(id)) {
      _goodLists.forEach((item) {
        if (item.id == id) {
          result = item.stock;
        }
      });
    } else {
      return null;
    }
    return result;
  }
}

class Good {
  int id; // 商品id
  String goodName; // 商品名字
  int stock; // 商品库存
  String expressCost; // 商品运费
  int sales; // 商品销量
  String imgCover; // 商品封面

  Good(int id, String goodName, int stock, int sales, String expressCost,
      String imgCover) {
    this.id = id;
    this.goodName = goodName;
    this.stock = stock;
    this.sales = sales;
    this.expressCost = expressCost;
    this.imgCover = imgCover;
  }
}
