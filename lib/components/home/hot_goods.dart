import 'package:flutter/material.dart';
import 'package:commerce_shop_flutter/config/service_method.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HotGoods extends StatefulWidget {
  @override
  _HotGoodsState createState() => _HotGoodsState();
}

class _HotGoodsState extends State<HotGoods> {
  var page = 1;
  List goodsList;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getData('hotGoods', formdata: {"page": page}),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          } else {
            goodsList = snapshot.data['data']['goodsList'];
            return Container(
              width: ScreenUtil.getInstance().setWidth(750),
              // height: ScreenUtil.getInstance().setHeight(500),
              color: Color.fromRGBO(245, 245, 245, 0.8),
              child: Column(
                children: <Widget>[hotGoodsTitle(), hotGoodsList()],
              ),
            );
          }
        } else {
          return Center(child: CircularProgressIndicator()); // 请求未结束，显示loading
        }
      },
    );
  }

  // 热门商品标题
  Widget hotGoodsTitle() {
    return Container(
      height: ScreenUtil.getInstance().setHeight(80),
      width: ScreenUtil.getInstance().setWidth(750),
      color: Colors.white,
      alignment: Alignment.center,
      child: Text('热门商品'),
    );
  }

  // 热门商品列表
  Widget hotGoodsList() {
    return Wrap(
        spacing: 2,
        children: goodsList.map((item) {
          return hotGoodsItem(item);
        }).toList());
  }

  // 热门商品子项
  Widget hotGoodsItem(item) {
    var id = item['id'];
    var name = item['name'];
    var price = item['price'];
    var desc = item['desc'];
    var carriage = item['carriage'];
    var monthlySales = item['monthlySales'];
    var yieldly = item['yieldly'];
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, 'homeGoodsDetail',
            arguments:
                '{"id":$id,"name":"$name","price":$price,"desc":"$desc","carriage":"$carriage","monthlySales":"$monthlySales","yieldly":"$yieldly"}');
      },
      child: Container(
        width: ScreenUtil().setWidth(360),
        height: ScreenUtil().setHeight(340),
        child: Column(
          children: <Widget>[
            Image.network(
              item['imgUrl'],
              width: ScreenUtil().setWidth(340),
              height: ScreenUtil().setHeight(240),
            ),
            Text(
              item['name'],
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(item['price']),
          ],
        ),
      ),
    );
  }
}

class PetCardViewModel {
  /// 封面地址
  final String coverUrl;

  /// 用户头像地址
  final String userImgUrl;

  /// 用户名
  final String userName;

  const PetCardViewModel({
    this.coverUrl,
    this.userImgUrl,
    this.userName,
  });
}
