// 通用CheckBox
import 'package:flutter/material.dart';

class CirCleBox extends StatelessWidget {
  final bool ifCheck;
  final double width;
  final double height;
  final callback;
  CirCleBox(
      {this.ifCheck = false,
      this.width = 30.0,
      this.height = 30.0,
      this.callback});
  @override
  Widget build(BuildContext context) {
    return ifCheck
        ? Container(
            width: width,
            height: height,
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: Colors.red),
            child: InkWell(
              child: Icon(
                Icons.check,
                size: 20.0,
                color: Colors.white,
              ),
              onTap: () {
                callback();
              },
            ))
        : Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                border: Border.all(width: 1)),
            child: InkWell(
              onTap: () {
                callback();
              },
            ));
  }
}
