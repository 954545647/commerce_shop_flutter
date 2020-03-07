import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:commerce_shop_flutter/utils/dio.dart';
import "package:commerce_shop_flutter/config/config.dart";

class HotGoods extends StatefulWidget {
  @override
  _HotGoodsState createState() => _HotGoodsState();
}

class _HotGoodsState extends State<HotGoods> {
  List goodsList;
  bool ifShowLoading = true;
  @override
  void initState() {
    getAllGoods();
    super.initState();
  }

// 获取所有商品
  getAllGoods() {
    DioUtils.getInstance().post('getAllGoods').then((val) {
      if (val != null && val["data"] != null) {
        setState(() {
          goodsList = val["data"];
          ifShowLoading = false;
        });
      }
    });
  }

// 保存当前点击商品的id
  saveGoodId(goodId) {
    DioUtils.getInstance().post('saveId', data: {"goodId": goodId});
  }

  @override
  Widget build(BuildContext context) {
    return ifShowLoading
        ? Text("")
        : Container(
            width: ScreenUtil.getInstance().setWidth(750),
            // height: ScreenUtil.getInstance().setHeight(500),
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
      child: Text('热门商品'),
    );
  }

  // 热门商品子项
  Widget hotGoodsItem(item) {
    var id = item['id'];
    var name = item['goodName'];
    var price = item['price'];
    var desc = item['descript'];
    var stock = item['stock'];
    var imgCover = item['imgCover'];
    var sales = item['sales'];
    var expressCost = item['expressCost'];
    var from = item['from'];
    var supplierId = item['supplierId'];
    return GestureDetector(
      onTap: () {
        saveGoodId(id);
        Navigator.pushNamed(context, 'homeGoodsDetail',
            arguments:
                '{"id":$id,"name":"$name","price":$price,"desc":"$desc","stock":"$stock","imgCover":"$imgCover","sales":"$sales","expressCost":"$expressCost","supplierId":$supplierId,"from":"$from"}');
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
            Image.network("${Config.apiHost}$imgCover",
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
                      Text("￥${price.toString()}",
                          style: TextStyle(
                              // color: Color.fromRGBO(201, 66, 45, 1),
                              color: Colors.red,
                              fontSize: 25,
                              fontWeight: FontWeight.bold)),
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
