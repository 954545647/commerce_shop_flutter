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
  add(
    id,
    supplierId,
    goodName,
    imgCover,
  ) {
    if (has(id)) {
      return;
    } else {
      _goodLists.add(new Good(id, supplierId, goodName, imgCover));
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
}

class Good {
  int id; // 商品id
  int supplierId; // 商家Id
  String goodName; // 商品名字
  String imgCover; // 商品封面

  Good(
    int id,
    int supplierId,
    String goodName,
    String imgCover,
  ) {
    this.id = id;
    this.goodName = goodName;
    this.imgCover = imgCover;
    this.supplierId = supplierId;
  }
}
