// 新增土地
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:commerce_shop_flutter/components/common/top_title.dart';
import 'package:image_picker/image_picker.dart';
import 'package:city_pickers/city_pickers.dart';
import '../common/textField.dart';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:commerce_shop_flutter/utils/dio.dart';
import 'package:commerce_shop_flutter/config/config.dart';
import 'package:provider/provider.dart';
import 'package:commerce_shop_flutter/provider/supplierData.dart';
import 'package:commerce_shop_flutter/components/common/toast.dart';
import "package:commerce_shop_flutter/utils/diaLog.dart";

class PublishLand extends StatefulWidget {
  @override
  _PublishLandState createState() => _PublishLandState();
}

class _PublishLandState extends State<PublishLand> {
  TextEditingController _nameController = new TextEditingController(); // 农场名字
  TextEditingController _descController = new TextEditingController(); // 农场简介
  TextEditingController _labelController = new TextEditingController(); // 农场标签
  TextEditingController _coverController = new TextEditingController(); // 农场标签
  TextEditingController _totalNumController =
      new TextEditingController(); // 农场可租总数
  TextEditingController _preAreaController =
      new TextEditingController(); // 农场土地单位面积
  TextEditingController _preMoneyController =
      new TextEditingController(); // 农场土地单位租金
  TextEditingController _monitorController =
      new TextEditingController(); // 农场监控地址
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
    getOrders();
  }

  // 获取全部订单
  getOrders() {}

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
    var res =
        await getData("supplier/upload", data: formData, baseUrl: BASEURL);
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
        _labelController.text == "" ||
        _totalNumController.text == "" ||
        _preAreaController.text == "" ||
        _monitorController.text == "" ||
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
    String desc = _descController.text;
    String label = _labelController.text;
    String totalNum = _totalNumController.text;
    String preArea = _preAreaController.text;
    String preMoney = _preMoneyController.text;
    String monitor = _monitorController.text;
    int id = supplier.supplierInfo.id;
    DioUtils.getInstance().post("newFarm", data: {
      "supplierId": id,
      "farmName": name,
      "descript": desc,
      "tags": label,
      "totalNum": totalNum,
      "preArea": preArea,
      "preMoney": preMoney,
      "imgCover": enterUrl ? _coverController.text : serverImg,
      "monitor": monitor,
      "address": location,
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
    _labelController.text = "";
    _totalNumController.text = "";
    _preAreaController.text = "";
    _preMoneyController.text = "";
    _monitorController.text = "";
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
            title: "新增农场",
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
                // 农场名称
                SingleItem(
                  title: "农场名称",
                  detail: "请输入农场名称",
                  itemController: _nameController,
                  ifNum: false,
                ),
                enterUrl
                    ? SingleItem(
                        title: "农场封面",
                        detail: "输入农场封面地址",
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
                            child: Text("农场封面"),
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
          // 农场简介
          SingleItem(
            title: "农场简介",
            detail: "请输入农场简介",
            itemController: _descController,
            ifNum: false,
          ),
          // 农场标签
          SingleItem(
            title: "农场标签",
            detail: "请输入农场标签（以空格分割）",
            itemController: _labelController,
            ifNum: false,
          ),
          // 可租总数
          SingleItem(
            title: "可租总数",
            detail: "请输入农场总租地数量",
            itemController: _totalNumController,
          ),
          // 单位面积
          SingleItem(
            title: "单位面积",
            detail: "请输入单位面积",
            itemController: _preAreaController,
          ),
          // 单位租金
          SingleItem(
            title: "单位租金",
            detail: "请输入单块土地面积",
            itemController: _preMoneyController,
          ),
          // 监控地址
          SingleItem(
            title: "监控地址",
            detail: "请输入监控地址",
            itemController: _monitorController,
            ifNum: false,
          ),
          // 农场地址
          Row(
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                width: ScreenUtil().setWidth(150),
                height: ScreenUtil().setHeight(100),
                decoration: BoxDecoration(color: Colors.white),
                child: Text("农场地址"),
              ),
              Container(
                width: ScreenUtil().setWidth(600),
                height: ScreenUtil().setHeight(100),
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
                        FocusScope.of(context).requestFocus(FocusNode());
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
              commonDialog(
                context: context,
                title: "重要提示！！！",
                detail: "必须在当前农场下发布农场品才能上线商城",
                needSkip: false,
                method: () {
                  publish();
                },
              );
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
}
