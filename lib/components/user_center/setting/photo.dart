import 'package:flutter/material.dart';
import 'package:commerce_shop_flutter/components/common/top_title.dart';
import 'package:commerce_shop_flutter/utils/dio.dart';
import 'package:commerce_shop_flutter/components/supplier/common/textField.dart';
import 'package:commerce_shop_flutter/components/supplier/common/imageView.dart';
import 'package:dio/dio.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:commerce_shop_flutter/config/config.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:commerce_shop_flutter/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:commerce_shop_flutter/provider/userData.dart';
import 'package:commerce_shop_flutter/components/common/toast.dart';

class Photo extends StatefulWidget {
  @override
  _PhotoState createState() => _PhotoState();
}

class _PhotoState extends State<Photo> {
  File coverImg;
  String serverImg;
  bool enterUrl = false; // 封面地址是否使用url
  TextEditingController _coverController = new TextEditingController(); // 商品标签

  // 使用本地图片
  Future _getPhoto() async {
    var img = await ImagePicker.pickImage(source: ImageSource.gallery);
    coverImg = img;
    uploadPhoto(img);
    setState(() {});
  }

  // 拍照
  Future _getImageFromCamera() async {
    var img =
        await ImagePicker.pickImage(source: ImageSource.camera, maxWidth: 400);
    coverImg = img;
    uploadPhoto(img);
    setState(() {});
  }

  // 上传图片
  Future uploadPhoto(File img) async {
    if (img == null) {
      return;
    }
    String fileDir = img.path;
    FormData formData =
        FormData.fromMap({"file": await MultipartFile.fromFile(fileDir)});
    var res = await getData("utils/upload", data: formData, baseUrl: BASEURL);
    if (res != null && res["url"] != null) {
      serverImg = res["url"];
    }
    setState(() {});
  }

  // 更新用户资料
  Future updateUserInfo() async {
    return await DioUtil.getInstance(context)
        .post("updateImg", data: {"imgCover": serverImg});
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserData>(context);
    return Scaffold(
      body: Container(
          color: Colors.white,
          child: Column(
            children: <Widget>[
              TopTitle(
                title: "修改头像",
                showArrow: true,
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                height: enterUrl
                    ? ScreenUtil().setHeight(220)
                    : ScreenUtil().setHeight(320),
                width: ScreenUtil().setWidth(750),
                alignment: Alignment.center,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    enterUrl
                        ? SingleItem(
                            title: "头像地址",
                            detail: "输入头像地址",
                            itemController: _coverController,
                            ifNum: false,
                          )
                        : Row(
                            children: <Widget>[
                              Container(
                                alignment: Alignment.center,
                                width: ScreenUtil().setWidth(150),
                                height: ScreenUtil().setHeight(100),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                ),
                                child: Text("上传头像"),
                              ),
                              GestureDetector(
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                            title: Text('选择上传方式'),
                                            actions: <Widget>[
                                              new FlatButton(
                                                child: new Text("输入URL"),
                                                onPressed: () {
                                                  enterUrl = true;
                                                  setState(() {});
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                              new FlatButton(
                                                child: new Text("本地相册"),
                                                onPressed: () {
                                                  _getPhoto();
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                              new FlatButton(
                                                child: new Text("拍照"),
                                                onPressed: () {
                                                  _getImageFromCamera();
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                            ],
                                          ));
                                },
                                child: Container(
                                  margin: EdgeInsets.fromLTRB(0, 10, 20, 0),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 1,
                                        color: coverImg != null
                                            ? Colors.white
                                            : Colors.black45),
                                  ),
                                  height: ScreenUtil().setHeight(180),
                                  width: ScreenUtil().setWidth(180),
                                  child: ImageView("头像", coverImg, coverImg),
                                ),
                              )
                            ],
                          )
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                height: 50,
                child: RaisedButton(
                  onPressed: () async {
                    var data = await updateUserInfo();
                    if (data != null) {
                      String newCover = "${cutPath(serverImg)}";
                      user.updateCover(user.userInfo.id, newCover);
                      Navigator.pop(context);
                    } else {
                      Toast.toast(context, msg: "更新失败");
                    }
                  },
                  child: Text("确认提交"),
                ),
              )
            ],
          )),
    );
  }
}
