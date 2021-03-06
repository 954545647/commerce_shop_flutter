import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:commerce_shop_flutter/utils/dio.dart';
import "package:commerce_shop_flutter/config/config.dart";

class HotAdopt extends StatefulWidget {
  @override
  _HotAdoptState createState() => _HotAdoptState();
}

class _HotAdoptState extends State<HotAdopt> {
  List goodsList;
  bool ifShowLoading = true;
  @override
  void initState() {
    getHotAdopt();
    super.initState();
  }

// 获取所有商品
  getHotAdopt() {
    DioUtil.getInstance(context).get('hotAdopts').then((val) {
      if (val != null && val["data"] != null) {
        goodsList = val["data"];
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
                    children: goodsList.map((item) {
                  return hotGoodsItem(item);
                }).toList())
              ],
            ),
          );
  }

  // 热门认养标题
  Widget hotGoodsTitle() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
              bottom: BorderSide(color: Color.fromRGBO(239, 239, 239, 1)))),
      height: ScreenUtil.getInstance().setHeight(100),
      width: ScreenUtil.getInstance().setWidth(750),
      alignment: Alignment.center,
      child: Text('热门认养'),
    );
  }

  // 热门认养子项
  Widget hotGoodsItem(item) {
    var name = item['goodName'];
    var price = item['price'];
    var desc = item['descript'];
    var imgCover = item['imgCover'];
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, "homeGoodsDetail", arguments: item);
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
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text(
                        name.toString(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 20),
                      ),
                      Text("￥${price.toString()}",
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 25,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Text(
                    desc.toString(),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
