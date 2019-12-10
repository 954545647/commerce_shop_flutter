import 'package:flutter/material.dart';
import 'package:commerce_shop_flutter/config/service_method.dart';
import 'package:commerce_shop_flutter/components/market/GoodsCard.dart';
import 'package:commerce_shop_flutter/model/goodsCardModel.dart';
class Market extends StatefulWidget {
  @override
  _MarketState createState() => _MarketState();
}

class _MarketState extends State<Market> {
  var goodsList = [];
  @override
  void initState() {
    super.initState();
    getData('goodsList').then((val) {
      setState(() {
        goodsList = val['data']['goodsList'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('集市'),
      ),
      body: Center(
          child: ListView(
              children: goodsList.map((item) {
        GoodsCardModel goodsModel = GoodsCardModel.fromJson(item);
        return GoodsCard(data: goodsModel);
      }).toList())),
    );
  }
}
