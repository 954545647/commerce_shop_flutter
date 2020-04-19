import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:commerce_shop_flutter/components/common/top_title.dart';
import 'package:image_picker/image_picker.dart';
import 'package:city_pickers/city_pickers.dart';
import '../common/textField.dart';
import '../common/imageView.dart';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:commerce_shop_flutter/utils/dio.dart';
import 'package:commerce_shop_flutter/components/common/toast.dart';
import 'package:commerce_shop_flutter/config/config.dart';
import 'package:provider/provider.dart';
import 'package:commerce_shop_flutter/provider/supplierData.dart';

class PublishAnimal extends StatefulWidget {
  @override
  _PublishAnimalState createState() => _PublishAnimalState();
}

class _PublishAnimalState extends State<PublishAnimal> {
  TextEditingController _nameController = new TextEditingController(); // 家禽名字
  TextEditingController _descController = new TextEditingController(); // 农场简介
  TextEditingController _priceController = new TextEditingController(); // 价格
  TextEditingController _stockController = new TextEditingController(); // 库存
  TextEditingController _coverController = new TextEditingController(); // 家禽标签
  TextEditingController _expressController =
      new TextEditingController(); // 家禽标签
  String defaultTitle = "例如：【走地鸡】新鲜活泼";
  String location = "点我选择地区";
  String province = "";
  String city = "";
  String area = "";
  File coverImg;
  String serverImg;
  bool enterUrl = false; // 封面地址是否使用url
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
        _priceController.text == "" ||
        _stockController.text == "" ||
        _expressController.text == "" ||
        _descController.text == "" ||
        serverImg == null ||
        location == "") {
      result = false;
    }
    return result;
  }

  // 发布
  void publish() {
    final supplier = Provider.of<SupplierData>(context);
    String name = _nameController.text;
    String descript = _descController.text;
    String price = _priceController.text;
    String stock = _stockController.text;
    String expressCost = _expressController.text;
    int id = supplier.supplierInfo.id;
    DioUtil.getInstance(context).post("SnewGood", data: {
      "supplierId": id,
      "goodName": name,
      "descript": descript,
      "price": price,
      "stock": stock,
      "expressCost": expressCost,
      "imgCover": enterUrl ? _coverController.text : serverImg,
      "from": location,
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
    _stockController.text = "";
    _coverController.text = "";
    _expressController.text = "";
    _coverController.text = "";
    location = "点我选择地区";
    coverImg = null;
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
            title: "发布家禽",
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
                // 家禽名称
                SingleItem(
                  title: "家禽名称",
                  detail: "请输入家禽名称",
                  itemController: _nameController,
                  ifNum: false,
                ),
                enterUrl
                    ? SingleItem(
                        title: "家禽封面",
                        detail: "输入家禽封面地址",
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
                            child: Text("家禽封面"),
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
                              child: ImageView("家禽封面", coverImg, coverImg),
                            ),
                          )
                        ],
                      )
              ],
            ),
          ),
          // 家禽价格
          SingleItem(
            title: "家禽描述",
            detail: "请输入家禽描述",
            itemController: _descController,
            ifNum: false,
          ),
          // 家禽价格
          SingleItem(
            title: "家禽价格",
            detail: "请输入家禽价格",
            itemController: _priceController,
            ifNum: true,
          ),
          // 家禽库存
          SingleItem(
            title: "家禽库存",
            detail: "请输入家禽库存",
            itemController: _stockController,
            ifNum: true,
          ),
          // 快递费用
          SingleItem(
            title: "快递费用",
            detail: "请输入快递费用",
            itemController: _expressController,
            ifNum: true,
          ),
          Row(
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                width: ScreenUtil().setWidth(150),
                height: ScreenUtil().setHeight(120),
                decoration: BoxDecoration(color: Colors.white),
                child: Text("发源地"),
              ),
              Container(
                width: ScreenUtil().setWidth(600),
                height: ScreenUtil().setHeight(120),
                padding: EdgeInsets.fromLTRB(0, 0, 30, 0),
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: Row(
                  children: <Widget>[
                    GestureDetector(
                      child: Text(
                        location,
                        style: TextStyle(
                            fontSize: 17,
                            color: Color.fromRGBO(141, 141, 141, 1)),
                      ),
                      onTap: () async {
                        Result result = await CityPickers.showCityPicker(
                          context: context,
                        );
                        String local = result.provinceName +
                            result.cityName +
                            result.areaName;
                        setState(() {
                          province = result.provinceName;
                          city = result.cityName;
                          area = result.areaName;
                          location = local;
                        });
                      },
                    ),
                  ],
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
                Toast.toast(context, msg: "请填写完整信息");
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
