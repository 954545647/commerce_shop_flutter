import 'package:flutter/material.dart';
import 'package:commerce_shop_flutter/components/rent_land/top_banner.dart';

class RentLand extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: Container(
            child: Column(
          children: <Widget>[TopBanner()],
        )),
      ),
    );
  }
}
