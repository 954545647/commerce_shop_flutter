import 'package:flutter/material.dart';
import 'package:commerce_shop_flutter/components/shop/goods_card.dart';
import 'package:commerce_shop_flutter/utils/dio.dart';

class CardList extends StatefulWidget {
  @override
  _CardListState createState() => _CardListState();
}

class _CardListState extends State<CardList> {
  var goodsList = [];
  @override
  void initState() {
    super.initState();
    getGoodList();
  }

// 获取商品信息
  getGoodList() {
    DioUtils.getInstance().post('getAllGoods').then((val) {
      if (val != null && val["data"] != null) {
        setState(() {
          goodsList = val['data'];
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
          child: SingleChildScrollView(
        child: Column(
            children: goodsList.map((item) {
          return GoodsCard(data: item);
        }).toList()),
      )),
    );
  }
}
