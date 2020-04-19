import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:commerce_shop_flutter/components/common/top_title.dart';
import 'package:commerce_shop_flutter/utils/dio.dart';
import "package:commerce_shop_flutter/config/config.dart";

class NearFarm extends StatefulWidget {
  @override
  _NearFarmState createState() => _NearFarmState();
}

class _NearFarmState extends State<NearFarm> {
  List farmList = [];
  List imgList = [];

  @override
  void initState() {
    super.initState();
    getFarms();
  }

  getFarms() async {
    var data = await DioUtil.getInstance(context).get('getAllFarmsInfo');
    if (data != null && data["data"] != null) {
      data["data"].forEach((item) {
        imgList.add("${Config.apiHost}/${item["farmInfo"]["imgCover"]}");
      });
      farmList = data["data"];
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: Container(
          color: Colors.white,
          child: ListView(
            children: <Widget>[
              // 标题
              TopTitle(
                title: '农场列表',
                showArrow: true,
              ),
              // 农场列表
              farmLists(),
            ],
          ),
        ),
      ),
    );
  }

  // 商家列表
  Widget farmLists() {
    return Container(
      margin: EdgeInsets.all(15),
      child: Column(
        children: farmList.map((item) {
          return merchantDetail(item);
        }).toList(),
      ),
    );
  }

  // 商家详情
  Widget merchantDetail(data) {
    var farmInfo = data["farmInfo"];
    var supplierInfo = data["farmInfo"]["Supplier_Info"];
    var cropInfo = data["farmInfo"]["cropInfo"];
    return GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, 'supplier', arguments: supplierInfo);
        },
        child: Container(
          padding: EdgeInsets.all(15),
          height: cropInfo.length > 0
              ? ScreenUtil().setHeight(540)
              : ScreenUtil().setHeight(300),
          margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black12),
              borderRadius: BorderRadius.circular(20)),
          child: Column(
            children: <Widget>[
              Container(
                height: ScreenUtil().setHeight(250),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Image.network(
                      "${Config.apiHost}/${farmInfo['imgCover']}",
                      width: ScreenUtil().setWidth(240),
                      height: ScreenUtil().setHeight(240),
                      fit: BoxFit.cover,
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            farmInfo['farmName'],
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          SizedBox(height: 10),
                          Text(
                            farmInfo['address'],
                            style: TextStyle(color: Colors.grey),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Container(
                child: cropList(cropInfo),
              )
            ],
          ),
        ));
  }

  Widget cropList(data) {
    List<Widget> list = [];
    for (var i = 0; i < data.length; i++) {
      list.add(cropItem(data[i]));
    }
    return Row(
      children: list,
    );
  }

  Widget cropItem(data) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 15, 15, 0),
      child: Column(
        children: <Widget>[
          Image.network(
            "${Config.apiHost}/${data["imgCover"]}",
            width: ScreenUtil().setWidth(150),
            height: ScreenUtil().setHeight(150),
            fit: BoxFit.cover,
          ),
          Row(
            children: <Widget>[
              Text(data["cropName"]),
            ],
          )
        ],
      ),
    );
  }
}
