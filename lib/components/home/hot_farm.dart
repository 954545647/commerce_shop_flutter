import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:commerce_shop_flutter/utils/dio.dart';
import "package:commerce_shop_flutter/config/config.dart";

class HotFarm extends StatefulWidget {
  @override
  _HotFarmState createState() => _HotFarmState();
}

class _HotFarmState extends State<HotFarm> {
  List farmList;
  bool ifShowLoading = true;
  @override
  void initState() {
    getHotFarm();
    super.initState();
  }

// 获取所有商品
  getHotFarm() {
    DioUtil.getInstance(context).get('hotFarms').then((val) {
      if (val != null && val["data"] != null) {
        farmList = val["data"];
        ifShowLoading = false;
        if (mounted) {
          setState(() {});
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ifShowLoading
        ? Text("")
        : Container(
            width: ScreenUtil.getInstance().setWidth(750),
            color: Color.fromRGBO(245, 245, 245, 0.8),
            child: Column(
              children: <Widget>[
                hotGoodsTitle(),
                Column(
                    children: farmList.map((item) {
                  return hotGoodsItem(item);
                }).toList())
              ],
            ),
          );
  }

  // 热门商品标题
  Widget hotGoodsTitle() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
              bottom: BorderSide(color: Color.fromRGBO(239, 239, 239, 1)))),
      height: ScreenUtil.getInstance().setHeight(100),
      width: ScreenUtil.getInstance().setWidth(750),
      alignment: Alignment.center,
      child: Text('热门租地'),
    );
  }

  // 热门商品子项
  Widget hotGoodsItem(item) {
    var farmInfo = item["farmInfo"];
    var name = farmInfo['farmName'];
    var desc = farmInfo['descript'];
    var imgCover = farmInfo['imgCover'];
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, "farmDetail", arguments: farmInfo);
      },
      child: Container(
        height: ScreenUtil().setHeight(340),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
                bottom: BorderSide(color: Color.fromRGBO(242, 242, 242, 1)))),
        padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
        child: Row(
          children: <Widget>[
            Image.network("${Config.apiHost}/$imgCover",
                width: ScreenUtil().setWidth(300),
                height: ScreenUtil().setHeight(300),
                fit: BoxFit.cover),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    desc.toString(),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 20),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text(
                        name.toString(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
