import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/services.dart';

class SingleItem extends StatefulWidget {
  SingleItem({this.itemController, this.title, this.detail, this.ifNum = true});
  final String title;
  final String detail;
  final itemController;
  final bool ifNum;
  @override
  _SingleItemState createState() => _SingleItemState();
}

class _SingleItemState extends State<SingleItem> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          alignment: Alignment.center,
          width: ScreenUtil().setWidth(150),
          height: ScreenUtil().setHeight(100),
          decoration: BoxDecoration(color: Colors.white),
          child: Text(widget.title),
        ),
        Container(
          width: ScreenUtil().setWidth(600),
          height: ScreenUtil().setHeight(100),
          decoration: BoxDecoration(color: Colors.white),
          padding: EdgeInsets.fromLTRB(0, 0, 30, 0),
          child: TextField(
            controller: widget.itemController,
            onChanged: (v) {
              setState(() {});
            },
            inputFormatters: [
              // 长度限制
              LengthLimitingTextInputFormatter(18),
              widget.ifNum
                  ? WhitelistingTextInputFormatter.digitsOnly
                  : LengthLimitingTextInputFormatter(20)
            ],
            keyboardType:
                widget.ifNum ? TextInputType.phone : TextInputType.text,
            style: TextStyle(fontSize: 16.0, color: Colors.black),
            decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 16.0),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.black54,
                        style: BorderStyle.solid)), //获取焦点时，下划线的样式
                hintText: "${widget.detail}"),
          ),
        ),
      ],
    );
  }
}
