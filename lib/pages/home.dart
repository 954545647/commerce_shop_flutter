import 'package:flutter/material.dart';
import 'package:commerce_shop_flutter/components/welcome/UserCenter.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('首页'),
      ),
      body: Center(
        child: UserCenter(),
      ),
    );
  }
}
