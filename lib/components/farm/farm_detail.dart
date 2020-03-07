import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:commerce_shop_flutter/config/style.dart' as config;
import 'package:commerce_shop_flutter/components/common/top_title.dart';
import 'package:commerce_shop_flutter/components/common/toast.dart';
// import 'package:commerce_shop_flutter/utils/dio.dart';
import "package:commerce_shop_flutter/config/config.dart";

class FarmDetail extends StatefulWidget {
  @override
  _FarmDetailState createState() => _FarmDetailState();
}

class _FarmDetailState extends State<FarmDetail> {
  ScrollController _controller = ScrollController();
  double _opacity = 0.0;
  int areaNum = 1; // 选择土地的块数
  List cropNum = []; // 农作物的个数
  int cropTotal = 0; // 农作物的总个数
  int total = 0; // 下单总价
  var orderInfo = {}; // 订单详情
  @override
  void initState() {
    super.initState();
    double t;
    _controller.addListener(() {
      t = this._controller.offset / config.topPadding;
      setState(() {
        if (t >= 1.0) {
          this._opacity = 1.0;
        } else if (t < 0.0) {
          this._opacity = 0.0;
        } else {
          this._opacity = t;
        }
      });
    });
  }

// 解析标签
  splitTags(tags) {
    List<Widget> list = [];
    List tagList = tags.split(";");
    for (var i = 0; i < tagList.length; i++) {
      list.add(Container(
        margin: EdgeInsets.fromLTRB(0, 0, 15, 0),
        alignment: Alignment.center,
        width: ScreenUtil().setWidth(150),
        height: ScreenUtil().setHeight(60),
        decoration: BoxDecoration(
          border: Border.all(width: 1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(tagList[i]),
      ));
    }
    return list;
  }

// 文字块组件
  Widget textContainer(str, textStyle) {
    return Container(
      padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
      alignment: Alignment.centerLeft,
      height: ScreenUtil().setHeight(80),
      child: Text(str, style: textStyle),
    );
  }

// 获取当前选中的农作物个数
  int getTotalNum() {
    int total = 0;
    for (var i = 0; i < cropNum.length; i++) {
      total += cropNum[i];
    }
    return total;
  }

// 计算商品总价
  getTotalPrice(data, setSta) {
    int result = 0;
    for (var i = 0; i < data.length; i++) {
      result += data[i]["price"] * cropNum[i];
    }
    total = result;
    setSta(() {});
    return total;
  }

// 处理订单信息
  handleOrderInfo(data) {
    var cropInfo = data["cropInfo"];
    List lists = [];
    for (var i = 0; i < cropInfo.length; i++) {
      var curData = cropInfo[i];
      lists.add({
        "id": curData["id"],
        "name": curData["cropName"],
        "count": cropNum[i],
        "imgCover": curData["imgCover"],
        "price": curData["price"],
      });
    }
    orderInfo["crops"] = lists;
    orderInfo["total"] = total;
    orderInfo["areaNum"] = areaNum;
    orderInfo["farmId"] = data["id"];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Map arguments = ModalRoute.of(context).settings.arguments;
    int len = arguments["cropInfo"].length;
    cropNum = List<int>(len);
    cropNum.fillRange(0, len, 0);
    String farmName = arguments["farmName"];
    orderInfo["farmName"] = farmName;
    total = 0;
    return Scaffold(
      body: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: Container(
          // height: 1000,
          child: Stack(
            children: <Widget>[
              SingleChildScrollView(
                controller: _controller,
                child: Column(
                  children: <Widget>[
                    Container(
                      width: ScreenUtil().setWidth(750),
                      height: ScreenUtil().setHeight(450),
                      child: Image.network(
                        "${Config.apiHost}${arguments["imgCover"]}",
                        fit: BoxFit.cover,
                      ),
                    ),
                    textContainer("￥${arguments["preArea"]}",
                        TextStyle(color: Colors.red, fontSize: 20)),
                    Container(
                      padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                      child: Row(children: splitTags(arguments["tags"])),
                    ),
                    SizedBox(height: 10),
                    textContainer("$farmName",
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                    // 地址
                    Container(
                      padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                      alignment: Alignment.centerLeft,
                      height: ScreenUtil().setHeight(100),
                      child: Text("${arguments["address"]}",
                          style: TextStyle(fontSize: 18), maxLines: 2),
                    ),
                    SizedBox(height: 10),
                    // 农作物规格数量
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (context) => StatefulBuilder(
                            builder: (BuildContext context, setSta) {
                              return Container(
                                padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
                                height: 400,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      "土地（${arguments["preArea"]}m²/块）",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Container(
                                      height: ScreenUtil().setHeight(100),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          InkWell(
                                            onTap: () {
                                              if (areaNum <= 1) {
                                                Toast.toast(context,
                                                    msg: "最低选择量为1");
                                                return;
                                              }
                                              setSta(() {
                                                areaNum = areaNum - 1;
                                              });
                                            },
                                            child: Icon(IconData(0xe6e6,
                                                fontFamily: "myIcons")),
                                          ),
                                          SizedBox(width: 10),
                                          Text("$areaNum"),
                                          SizedBox(width: 10),
                                          InkWell(
                                            onTap: () {
                                              if (areaNum ==
                                                  arguments["remainNum"]) {
                                                Toast.toast(context,
                                                    msg: "库存不足啦");
                                                return;
                                              }
                                              setSta(() {
                                                areaNum = areaNum + 1;
                                              });
                                            },
                                            child: Icon(Icons.add),
                                          )
                                        ],
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.fromLTRB(0, 0, 0, 5),
                                      child: cropList(
                                          arguments["cropInfo"], setSta),
                                    ),
                                    Expanded(
                                      child: Container(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: <Widget>[
                                            Container(
                                              width: ScreenUtil().setWidth(320),
                                              height:
                                                  ScreenUtil().setHeight(100),
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                  color: Colors.white),
                                              child: Text(
                                                "￥$total",
                                                style: TextStyle(
                                                    color: Color.fromRGBO(
                                                        47, 184, 170, 1)),
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                if (getTotalNum() <
                                                    areaNum * 10) {
                                                  Toast.toast(context,
                                                      msg: "当前面积还没选满");
                                                  return;
                                                } else if (getTotalNum() >
                                                    areaNum * 10) {
                                                  Toast.toast(context,
                                                      msg: "超过面积了");
                                                  return;
                                                }
                                                Navigator.pop(context);
                                              },
                                              child: Container(
                                                alignment: Alignment.center,
                                                width:
                                                    ScreenUtil().setWidth(320),
                                                height:
                                                    ScreenUtil().setHeight(100),
                                                decoration: BoxDecoration(
                                                    color: Color.fromRGBO(
                                                        47, 184, 170, 1)),
                                                child: Text("确定"),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              );
                            },
                          ),
                        );
                      },
                      child: Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.fromLTRB(15, 10, 15, 0),
                        padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                        height: ScreenUtil().setHeight(100),
                        width: ScreenUtil().setWidth(750),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.white),
                        child: Text("请选择规格数量"),
                      ),
                    ),
                    SizedBox(
                      height: 300,
                    )
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                child: GestureDetector(
                  onTap: () {
                    if (getTotalNum() == 0) {
                      Toast.toast(context, msg: "还没选择农作物");
                      return;
                    }
                    handleOrderInfo(arguments);
                    Navigator.pushNamed(context, "farmOrder",
                        arguments: orderInfo);
                  },
                  child: Container(
                      alignment: Alignment.center,
                      height: ScreenUtil().setHeight(120),
                      width: ScreenUtil().setWidth(750),
                      color: Colors.white,
                      child: Text("提交订单")),
                ),
              ),
              this._opacity > 0
                  ? Positioned(
                      top: 0,
                      child: Container(
                          alignment: Alignment.center,
                          height: ScreenUtil().setHeight(150),
                          width: ScreenUtil().setWidth(750),
                          color: Colors.white,
                          child: TopTitle(title: "农场详情", showArrow: true)),
                    )
                  : Positioned(
                      top: 30,
                      left: 20,
                      child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(width: 1)),
                          alignment: Alignment.center,
                          height: ScreenUtil().setWidth(50),
                          width: ScreenUtil().setWidth(50),
                          child: InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(
                              Icons.arrow_left,
                              color: Colors.white,
                              size: 26,
                            ),
                          )),
                    )
            ],
          ),
        ),
      ),
    );
  }

// 农作物列表
  Widget cropList(data, setSta) {
    List<Widget> list = [];
    for (var i = 0; i < data.length; i++) {
      list.add(cropItem(data, data[i], i, setSta));
    }
    return Container(
      height: 220,
      child: ListView(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        children: list,
      ),
    );
  }

  Widget cropItem(totalData, data, index, setSta) {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
      height: ScreenUtil().setHeight(200),
      width: ScreenUtil().setWidth(220),
      decoration: BoxDecoration(color: Color.fromRGBO(51, 183, 171, 1)),
      child: Column(
        children: <Widget>[
          Image.network(
            "${Config.apiHost}${data["imgCover"]}",
            width: ScreenUtil().setWidth(160),
            height: ScreenUtil().setHeight(140),
            fit: BoxFit.cover,
          ),
          Text(
            data["cropName"],
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          Text(
            data["descript"],
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
          Text(
            "￥${data["price"]}/份",
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              InkWell(
                onTap: () {
                  int cur = cropNum[index];
                  if (cur == 0) {
                    Toast.toast(context, msg: "最低选择量为0");
                    return;
                  }
                  cropNum[index] = cropNum[index] - 1;
                  getTotalPrice(totalData, setSta);
                  setSta(() {});
                },
                child: Icon(IconData(0xe6e6, fontFamily: "myIcons")),
              ),
              SizedBox(width: 10),
              Text(cropNum[index].toString()),
              SizedBox(width: 10),
              InkWell(
                onTap: () {
                  if (getTotalNum() >= areaNum * 10) {
                    Toast.toast(context, msg: "超过面积限制了");
                    return;
                  }
                  cropNum[index] = cropNum[index] + 1;
                  getTotalPrice(totalData, setSta);
                  setSta(() {});
                },
                child: Icon(Icons.add),
              )
            ],
          ),
        ],
      ),
    );
  }
}
