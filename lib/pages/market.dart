import 'package:flutter/material.dart';
// import 'package:commerce_shop_flutter/config/service_method.dart';
import 'package:commerce_shop_flutter/components/shop/card_list.dart';
import 'package:commerce_shop_flutter/components/common/top_title.dart';

class Market extends StatefulWidget {
  @override
  _MarketState createState() => _MarketState();
}

class _MarketState extends State<Market> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: Column(
          children: <Widget>[TopTitle(title: '认养'), CardList()],
        ),
      ),
    );
  }
}
