// 新增地址
import 'package:flutter/material.dart';
import 'package:commerce_shop_flutter/components/common/top_title.dart';
import 'package:commerce_shop_flutter/utils/dio.dart';
import 'package:city_pickers/city_pickers.dart';
import 'package:commerce_shop_flutter/components/common/toast.dart';
import 'package:provider/provider.dart';
import 'package:commerce_shop_flutter/provider/userData.dart';
import 'package:commerce_shop_flutter/utils/utils.dart';

class NewAddress extends StatefulWidget {
  @override
  _NewAddressState createState() => _NewAddressState();
}

class _NewAddressState extends State<NewAddress> {
  GlobalKey _formKey = new GlobalKey();
  TextEditingController _userController = new TextEditingController();
  TextEditingController _phoneController = new TextEditingController();
  TextEditingController _detailController = new TextEditingController();
  String location = "点我选择地区";
  String province = "";
  String city = "";
  String area = "";
  FocusNode focusNode1 = new FocusNode();
  FocusNode focusNode2 = new FocusNode();
  FocusNode focusNode3 = new FocusNode();
  FocusScopeNode focusScopeNode;

// 保存地址
  saveAddress(isDefault) async {
    String address = location + _detailController.text;
    // 新增地址接口
    var data = await DioUtil.getInstance(context).post("newAddress", data: {
      "username": _userController.text,
      "phone": _phoneController.text,
      "province": province,
      "city": city,
      "area": area,
      "address": address,
      "isDefault": isDefault
    });
    if (data != null) {
      if (data["errorCode"] == 0) {
        // 收起键盘
        FocusScope.of(context).requestFocus(FocusNode());
        // 清空表单内容
        _userController.clear();
        _phoneController.clear();
        _detailController.clear();
        setState(() {
          location = "点我选择地区";
        });
        Navigator.of(context).pop();
        Toast.toast(context, msg: "添加成功");
      } else {
        Navigator.of(context).pop();
        Toast.toast(context, msg: parseErrorMessage(data["msg"]));
      }
    } else {
      Navigator.of(context).pop();
      Toast.toast(context, msg: "添加失败");
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserData>(context);
    return Material(
      child: Container(
        child: Column(
          children: <Widget>[
            TopTitle(
              title: "新增地址",
              showArrow: true,
              ifRefresh: true,
            ),
            Container(
              child: Form(
                  key: _formKey, // 获取 FormState
                  autovalidate: false, // 自动校验
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        // 收件人
                        TextFormField(
                          controller: _userController,
                          focusNode: focusNode1,
                          decoration: InputDecoration(
                              labelText: '收件人', icon: Icon(Icons.person)),
                          validator: (v) {
                            return v.trim().length > 0 ? null : '收件人不能为空';
                          },
                        ),
                        // 手机号
                        TextFormField(
                            controller: _phoneController,
                            decoration: InputDecoration(
                                labelText: "手机号",
                                icon: Icon(Icons.phone_iphone)),
                            // 校验手机号
                            keyboardType: TextInputType.number,
                            focusNode: focusNode2,
                            validator: (v) {
                              int count = v.trim().length;
                              if (count != 11) {
                                return "手机号必须是11位";
                              }
                              RegExp mobile = new RegExp(r"^1[3-9]\d{9}$");
                              if (mobile.hasMatch(v)) {
                                return null;
                              } else {
                                return "手机格式不正确";
                              }
                            }),

                        // 地区选择
                        Container(
                          padding: EdgeInsets.fromLTRB(2, 0, 0, 0),
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                          height: 60.0,
                          alignment: Alignment.bottomCenter,
                          child: Row(
                            children: <Widget>[
                              Icon(Icons.location_city,
                                  color: Color.fromRGBO(141, 141, 141, 1)),
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.fromLTRB(2, 0, 0, 10),
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: Colors.grey, width: 1))),
                                  margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                  child: Row(
                                    children: <Widget>[
                                      GestureDetector(
                                        child: Text(
                                          location,
                                          style: TextStyle(
                                              fontSize: 17,
                                              color: Color.fromRGBO(
                                                  141, 141, 141, 1)),
                                        ),
                                        onTap: () async {
                                          FocusScope.of(context)
                                              .requestFocus(FocusNode());
                                          Result result =
                                              await CityPickers.showCityPicker(
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
                                          // 让详细地址获取焦点
                                          FocusScope.of(context)
                                              .requestFocus(focusNode3);
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        // 详细地址
                        TextFormField(
                            controller: _detailController,
                            focusNode: focusNode3,
                            decoration: InputDecoration(
                                labelText: "详细地址",
                                icon: Icon(Icons.phone_iphone)),
                            validator: (v) {
                              return v.trim().length > 0 ? null : '详细地址不能为空';
                            }),
                        RaisedButton(
                          child: Text("保存"),
                          onPressed: () async {
                            if ((_formKey.currentState as FormState)
                                .validate()) {
                              showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                        title: Text("是否添加为默认地址"),
                                        actions: <Widget>[
                                          new FlatButton(
                                            child: new Text("取消"),
                                            onPressed: () {
                                              FocusScope.of(context)
                                                  .requestFocus(FocusNode());
                                              String address = location +
                                                  _detailController.text;
                                              user.addAdress(
                                                  user.userInfo.id, address);
                                              saveAddress(false);
                                            },
                                          ),
                                          new FlatButton(
                                            child: new Text("确定"),
                                            onPressed: () {
                                              FocusScope.of(context)
                                                  .requestFocus(FocusNode());
                                              String address = location +
                                                  _detailController.text;
                                              user.addAdress(
                                                  user.userInfo.id, address);
                                              saveAddress(true);
                                            },
                                          ),
                                        ],
                                      ));
                            }
                          },
                        )
                      ],
                    ),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
