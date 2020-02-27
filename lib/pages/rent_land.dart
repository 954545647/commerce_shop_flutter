import 'package:flutter/material.dart';
import 'package:commerce_shop_flutter/components/common/top_title.dart';
import 'package:commerce_shop_flutter/components/farm/farm_list.dart';

class RentLand extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: Column(
          children: <Widget>[
            TopTitle(title: '租地'),
            Expanded(
              flex: 1,
              child: FarmList(),
            )
          ],
        ),
      ),
    );
  }
}
