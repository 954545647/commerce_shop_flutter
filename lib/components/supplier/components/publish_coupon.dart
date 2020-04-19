// 发布优惠卷
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:commerce_shop_flutter/components/common/top_title.dart';
import 'package:commerce_shop_flutter/components/common/toast.dart';
import '../common/textField.dart';
// import 'dart:io';
// import 'package:dio/dio.dart';
import 'package:commerce_shop_flutter/utils/dio.dart';
// import 'package:commerce_shop_flutter/config/config.dart';

class PublishCoupon extends StatefulWidget {
  @override
  _PublishCouponState createState() => _PublishCouponState();
}

class _PublishCouponState extends State<PublishCoupon> {
  TextEditingController _nameController = new TextEditingController(); // 名字
  TextEditingController _thresholdController =
      new TextEditingController(); // 阙值
  TextEditingController _faceController = new TextEditingController(); // 面值
  TextEditingController _countController = new TextEditingController(); // 优惠卷数量
  @override
  void initState() {
    super.initState();
  }

  // 判断是否填完表格
  bool ifFill() {
    if (_nameController.text == "" ||
        _faceController.text == "" ||
        _thresholdController.text == "" ||
        _countController.text == "") {
      return false;
    }
    return true;
  }

  // 判断字段填写是否符合规范
  String fieldOk() {
    String res = "";
    int threshold = int.parse(_thresholdController.text);
    int faceValue = int.parse(_faceController.text);
    int count = int.parse(_countController.text);
    if (threshold < faceValue) {
      res = "面值不能高于阙值";
    }
    if (count <= 0) {
      res = "发布数量不能小于1张";
    }
    return res;
  }

// 发布优惠卷
  publish() {
    String couponName = _nameController.text;
    int threshold = int.parse(_thresholdController.text);
    int faceValue = int.parse(_faceController.text);
    int count = int.parse(_countController.text);
    DioUtil.getInstance(context).post("SnewCoupon", data: {
      "name": couponName,
      "threshold": threshold,
      "faceValue": faceValue,
      "count": count
    }).then((val) {
      if (val != null && val["data"] != null) {
        Toast.toast(context, msg: "发布成功");
      } else {
        Toast.toast(context, msg: val["msg"]);
      }
    });
    resetData();
    setState(() {});
  }

  // 清空数据
  void resetData() {
    _nameController.text = "";
    _faceController.text = "";
    _thresholdController.text = "";
    _countController.text = "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: ListView(
        children: <Widget>[
          TopTitle(
            title: "发布优惠卷",
            showArrow: true,
            ifRefresh: true,
          ),
          // 优惠卷名称
          SingleItem(
            title: "名称",
            detail: "请输入优惠卷名称",
            itemController: _nameController,
            ifNum: false,
          ), // 优惠卷阙值
          SingleItem(
            title: "阙值",
            detail: "请输入优惠卷阙值",
            itemController: _thresholdController,
            ifNum: true,
          ),
          // 优惠卷面值
          SingleItem(
            title: "面值",
            detail: "请输入优惠卷面值",
            itemController: _faceController,
            ifNum: true,
          ),
          // 优惠卷数量
          SingleItem(
            title: "数量",
            detail: "请输入优惠卷数量",
            itemController: _countController,
            ifNum: true,
          ),
          SizedBox(
            height: 10,
          ),
          GestureDetector(
            onTap: () {
              if (!ifFill()) {
                Toast.toast(context, msg: "请填写完整表格");
                return;
              }
              String res = fieldOk();
              if (res != "") {
                Toast.toast(context, msg: res);
                return;
              }
              publish();
            },
            child: Container(
                width: ScreenUtil().setWidth(200),
                height: ScreenUtil().setHeight(100),
                margin: EdgeInsets.fromLTRB(50, 0, 50, 0),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Color.fromRGBO(200, 78, 67, 1),
                    borderRadius: BorderRadius.circular(15)),
                child: Text(
                  "发布",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                )),
          )
        ],
      ),
    ));
  }
}
