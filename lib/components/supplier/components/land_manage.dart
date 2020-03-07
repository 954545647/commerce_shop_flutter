// 租地管理
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:commerce_shop_flutter/utils/dio.dart';
// import 'package:provider/provider.dart';
// import 'package:commerce_shop_flutter/provider/supplierData.dart';

class LandManage extends StatefulWidget {
  LandManage(this.info);
  final info;
  @override
  _LandManageState createState() => _LandManageState();
}

class _LandManageState extends State<LandManage> {
  int hasBeenOn = 0;
  int notBeenOn = 0;
  List farmIds = [];
  @override
  void initState() {
    super.initState();
    getLands();
  }

  // 获取全部土地
  getLands() {
    if (widget.info != null && widget.info["id"] != null) {
      DioUtils.getInstance()
          .post("supplierFarm", data: {"id": widget.info["id"]}).then((val) {
        if (val != null && val["data"] != null) {
          hasBeenOn = 0;
          notBeenOn = 0;
          farmIds = [];
          val["data"].forEach((item) {
            farmIds.add({"id": item["id"], "farmName": item["farmName"]});
            if (item["status"] == 0) {
              notBeenOn++;
            } else {
              hasBeenOn++;
            }
          });
          setState(() {});
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: ScreenUtil().setWidth(750),
      height: ScreenUtil().setHeight(240),
      decoration: BoxDecoration(color: Colors.white),
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(
                        width: 1, color: Color.fromRGBO(216, 211, 211, 1)))),
            width: ScreenUtil().setWidth(750),
            height: ScreenUtil().setHeight(80),
            child: Text(
              "租地管理",
              style: TextStyle(color: Color.fromRGBO(90, 90, 90, 1)),
            ),
          ),
          Container(
            height: ScreenUtil().setHeight(160),
            alignment: Alignment.center,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Expanded(
                  child: GestureDetector(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(hasBeenOn.toString(),
                            style: TextStyle(fontSize: 18.0)),
                        Text(
                          '已上架',
                          style: TextStyle(fontSize: 14.0, color: Colors.grey),
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(notBeenOn.toString(),
                            style: TextStyle(fontSize: 18.0)),
                        Text(
                          '待上架',
                          style: TextStyle(fontSize: 14.0, color: Colors.grey),
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, "publishLand").then((val) {
                        if (val) {
                          getLands();
                        }
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: Color.fromRGBO(243, 248, 254, 1)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.add),
                          Text(
                            '发布新地',
                            style:
                                TextStyle(fontSize: 14.0, color: Colors.grey),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      List ids = farmIds;
                      Navigator.pushNamed(context, "publishCrop",
                              arguments: ids)
                          .then((val) {
                        if (val) {
                          getLands();
                        }
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: Color.fromRGBO(243, 248, 254, 1)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.add),
                          Text(
                            '发布菜品',
                            style:
                                TextStyle(fontSize: 14.0, color: Colors.grey),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
