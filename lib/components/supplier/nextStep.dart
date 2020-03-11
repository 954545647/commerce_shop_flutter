// 商家注册页面
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:commerce_shop_flutter/components/common/toast.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:commerce_shop_flutter/utils/dio.dart';
import 'package:commerce_shop_flutter/config/config.dart';

class NextStep extends StatefulWidget {
  @override
  _NextStepState createState() => _NextStepState();
}

class _NextStepState extends State<NextStep> {
  TextEditingController _idCardController = new TextEditingController(); // 手机号
  File frontImg; // 身份证正面
  File backImg; // 身份证背面
  String serverFrontImg;
  String serverBackImg;
  bool isFront = true;
  String idCard = "";

  @override
  void dispose() {
    super.dispose();
    _idCardController.dispose();
  }

  Future enter(data) async {
    await DioUtils.getInstance().post("newSupplier", data: {
      "username": data["username"],
      "password": data["password"],
      "phone": data["phone"],
      "idNum": _idCardController.text,
      "frontImg": serverFrontImg,
      "backImg": serverBackImg
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance =
        ScreenUtil(width: 750, height: 1334, allowFontScaling: true)
          ..init(context);
    Map<String, dynamic> userInfo = ModalRoute.of(context).settings.arguments;
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: Scaffold(
          body: ListView(
            children: <Widget>[
              Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  height: ScreenUtil().setHeight(240),
                  child: Row(
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.chevron_left,
                          size: 35,
                        ),
                      ),
                      Text("入驻凭证",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 28.0,
                              fontWeight: FontWeight.bold))
                    ],
                  )),
              // 身份证号码
              Container(
                padding: EdgeInsets.fromLTRB(25, 10, 25, 30),
                child: TextField(
                  controller: _idCardController,
                  onChanged: (v) {
                    setState(() {});
                  },
                  inputFormatters: [
                    // 长度限制
                    LengthLimitingTextInputFormatter(18),
                    // 数字限制
                    WhitelistingTextInputFormatter.digitsOnly,
                  ],
                  keyboardType: TextInputType.phone,
                  style: TextStyle(fontSize: 16.0, color: Colors.black),
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical: 15.0),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.black54,
                              style: BorderStyle.solid)), //获取焦点时，下划线的样式
                      hintText: '请输入身份证号'),
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                child: Column(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.centerLeft,
                      height: ScreenUtil().setHeight(100),
                      child: Text(
                        "身份证正、反面",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        imageView(frontImg, 0),
                        imageView(backImg, 1),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(10, 30, 10, 0),
                alignment: Alignment.center,
                height: ScreenUtil().setHeight(100),
                child: RaisedButton(
                  onPressed: () async {
                    if (_idCardController.text == "") {
                      Toast.toast(context, msg: "请填写身份证号码");
                      return;
                    }
                    if (serverFrontImg == null) {
                      Toast.toast(context, msg: "请上传身份证正面");
                      return;
                    }
                    if (serverBackImg == null) {
                      Toast.toast(context, msg: "请上传身份证反面");
                      return;
                    }
                    await DioUtils.getInstance().post("Ssregister", data: {
                      "username": userInfo["username"],
                      "password": userInfo["password"],
                      "phone": userInfo["phone"],
                      "idNum": _idCardController.text,
                      "frontImg": serverFrontImg,
                      "backImg": serverBackImg
                    }).then((val) {
                      if (val != null && val["data"] != null) {
                        Toast.toast(context, msg: "入驻成功");
                        // Navigator.pushReplacementNamed(context, "sLogin");
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            'sLogin', (Route<dynamic> route) => false);
                      } else {
                        Toast.toast(context, msg: val["msg"]);
                      }
                    });
                  },
                  child: Text("提交入驻"),
                ),
              )
            ],
          ),
        ));
  }

  Widget imageView(imgPath, i) {
    if (imgPath == null) {
      return Container(
          margin: EdgeInsets.fromLTRB(0, 0, 15, 0),
          width: ScreenUtil().setWidth(240),
          height: ScreenUtil().setHeight(240),
          decoration: BoxDecoration(color: Color.fromRGBO(228, 225, 229, 0.5)),
          alignment: Alignment.center,
          child: InkWell(
            child: Icon(
              Icons.add,
              size: 50,
            ),
            onTap: () {
              if (i == 1) {
                isFront = false;
              } else {
                isFront = true;
              }
              showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                        title: Text('选择上传方式'),
                        actions: <Widget>[
                          new FlatButton(
                            child: new Text("本地相册"),
                            onPressed: () {
                              _takePhoto();
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
              setState(() {});
            },
          ));
    } else {
      return Container(
        width: ScreenUtil().setWidth(240),
        height: ScreenUtil().setHeight(240),
        child: Image.file(
          imgPath,
          fit: BoxFit.contain,
        ),
      );
    }
  }

  // 拍照
  Future _getImageFromCamera() async {
    var img =
        await ImagePicker.pickImage(source: ImageSource.camera, maxWidth: 400);
    isFront ? frontImg = img : backImg = img;
    uploadPhoto(img);
    setState(() {});
  }

// 本地图片获取
  Future _takePhoto() async {
    var img = await ImagePicker.pickImage(source: ImageSource.gallery);
    isFront ? frontImg = img : backImg = img;
    uploadPhoto(img);
    setState(() {});
  }

// 上传图片
  void uploadPhoto(File img) async {
    if (img == null) {
      return;
    }
    String fileDir = img.path;
    FormData formData =
        FormData.fromMap({"file": await MultipartFile.fromFile(fileDir)});
    var res =
        await getData("supplier/upload", data: formData, baseUrl: BASEURL);
    isFront ? frontImg = img : backImg = img;
    if (res != null && res["url"] != null) {
      isFront ? serverFrontImg = res["url"] : serverBackImg = res["url"];
    }
  }
}
