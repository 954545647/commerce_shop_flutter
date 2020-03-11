import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:io';

class ImageView extends StatefulWidget {
  ImageView(
    this.title,
    this.imgPath,
    this.coverImg,
  );
  final String title;
  final File imgPath;
  final File coverImg;
  @override
  _ImageViewState createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  @override
  Widget build(BuildContext context) {
    if (widget.imgPath == null) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.camera_alt,
            size: 30,
          ),
          Text(widget.title)
        ],
      );
    } else {
      return Container(
        width: ScreenUtil().setWidth(240),
        height: ScreenUtil().setHeight(240),
        child: Image.file(
          widget.coverImg,
          fit: BoxFit.contain,
        ),
      );
    }
  }
}
