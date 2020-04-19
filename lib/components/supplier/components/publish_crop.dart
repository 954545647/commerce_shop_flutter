// 新增农场品
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:commerce_shop_flutter/components/common/top_title.dart';
import 'package:commerce_shop_flutter/components/common/toast.dart';
import '../common/textField.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:commerce_shop_flutter/utils/dio.dart';
import 'package:commerce_shop_flutter/config/config.dart';

class PublishCrop extends StatefulWidget {
  @override
  _PublishCropState createState() => _PublishCropState();
}

class _PublishCropState extends State<PublishCrop> {
  TextEditingController _nameController = new TextEditingController(); // 名字
  TextEditingController _priceController = new TextEditingController(); // 价格
  TextEditingController _descController = new TextEditingController(); // 简介
  TextEditingController _coverController = new TextEditingController(); // 农场品标签
  File coverImg;
  String serverImg = "";
  dynamic chooseItem; // 选中挂钩的农场
  bool enterUrl = false; // 封面地址是否使用url
  String chooseFarm = "选择挂钩农场";
  @override
  void initState() {
    super.initState();
  }

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

  // 判断是否填完表格
  bool ifFill() {
    bool result = true;
    if (enterUrl && _coverController.text == "") {
      result = false;
    }
    if (_nameController.text == "" ||
        _descController.text == "" ||
        _priceController.text == "" ||
        chooseItem == null ||
        serverImg == "") {
      result = false;
    }
    return result;
  }

// 发布
  publish() {
    String cropName = _nameController.text;
    String descript = _descController.text;
    String price = _priceController.text;
    int farmId = chooseItem["id"];
    DioUtil.getInstance(context).post("newCrop", data: {
      "cropName": cropName,
      "descript": descript,
      "price": price,
      "imgCover": enterUrl ? _coverController.text : serverImg,
      "farmId": farmId
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
    _descController.text = "";
    _priceController.text = "";
    _coverController.text = "";
    chooseFarm = "请选择挂钩农场";
    coverImg = null;
  }

  @override
  Widget build(BuildContext context) {
    List farmInfos = ModalRoute.of(context).settings.arguments;
    return Scaffold(
        body: MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: ListView(
        children: <Widget>[
          TopTitle(
            title: "发布农场品",
            showArrow: true,
            ifRefresh: true,
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            height: enterUrl
                ? ScreenUtil().setHeight(220)
                : ScreenUtil().setHeight(320),
            width: ScreenUtil().setWidth(750),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // 农场品名称
                SingleItem(
                  title: "农场品名称",
                  detail: "请输入农场品名称",
                  itemController: _nameController,
                  ifNum: false,
                ),
                enterUrl
                    ? SingleItem(
                        title: "农场品封面",
                        detail: "输入农场品封面地址",
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
                            child: Text("农场品封面"),
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
                              child: imageView(coverImg),
                            ),
                          )
                        ],
                      )
              ],
            ),
          ),
          // 农场品价格
          SingleItem(
            title: "农场品价格",
            detail: "请输入农场品价格",
            itemController: _priceController,
            ifNum: true,
          ),
          // 农场品简介
          SingleItem(
            title: "农场品简介",
            detail: "请输入农场品简介",
            itemController: _descController,
            ifNum: false,
          ),
          Row(
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                width: ScreenUtil().setWidth(150),
                height: ScreenUtil().setHeight(100),
                decoration: BoxDecoration(color: Colors.white),
                child: Text("挂钩农场"),
              ),
              Container(
                width: ScreenUtil().setWidth(600),
                height: ScreenUtil().setHeight(100),
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(color: Colors.white),
                padding: EdgeInsets.fromLTRB(0, 5, 50, 5),
                child: RaisedButton(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  color: Colors.white,
                  onPressed: () {
                    showModalBottomSheet(
                        context: context,
                        builder: (context) => Container(
                              color: Colors.white,
                              height: 300,
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    height: ScreenUtil().setHeight(80),
                                    width: ScreenUtil().setWidth(750),
                                    alignment: Alignment.center,
                                    child: Text(
                                      "全部农场",
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ),
                                  Container(
                                    child: Column(
                                        children: farmInfos.map((item) {
                                      return Container(
                                        child: farmItem(item),
                                      );
                                    }).toList()),
                                  )
                                ],
                              ),
                            ));
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                  child: Text(chooseFarm),
                ),
              ),
            ],
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

  // 上传图片
  Widget imageView(imgPath) {
    if (imgPath == null) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.camera_alt,
            size: 30,
          ),
          Text("土地封面")
        ],
      );
    } else {
      return Container(
        width: ScreenUtil().setWidth(240),
        height: ScreenUtil().setHeight(240),
        child: Image.file(
          coverImg,
          fit: BoxFit.contain,
        ),
      );
    }
  }

  // 商家农场
  Widget farmItem(data) {
    return GestureDetector(
      onTap: () {
        chooseItem = data;
        chooseFarm = data["farmName"];
        Navigator.pop(context);
        setState(() {});
      },
      child: Container(
        height: ScreenUtil().setHeight(100),
        width: ScreenUtil().setWidth(750),
        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(width: 1, color: Colors.black45)),
        child: Row(
          children: <Widget>[
            Text(
              data["farmName"],
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
