import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:commerce_shop_flutter/components/market/goods_card.dart';
import 'package:commerce_shop_flutter/model/goodsCardModel.dart';
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
    DioUtils.getInstance().get('goodsList').then((val) {
      setState(() {
        goodsList = val['data']['goodsList'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        height: ScreenUtil().setHeight(1000),
        child: ListView(
            children: goodsList.map((item) {
          GoodsCardModel goodsModel = GoodsCardModel.fromJson(item);
          return GoodsCard(data: goodsModel);
        }).toList()),
      ),
    );
  }
}
