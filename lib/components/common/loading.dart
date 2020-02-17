import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  final double width;
  final double height;
  Loading({this.width = 300.0, this.height = 500.0});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "资源正在飞速加载中",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Container(
                child: Image.asset("assets/images/loading3.gif"),
              )
            ],
          ),
        ),
        width: width,
        height: height,
      ),
    );
  }
}
