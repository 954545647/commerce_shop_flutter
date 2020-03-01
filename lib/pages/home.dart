import 'package:flutter/material.dart';
// import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:commerce_shop_flutter/components/home/home_swiper.dart';
import 'package:commerce_shop_flutter/components/home/menu_list.dart';
import 'package:commerce_shop_flutter/components/home/new_broad_cast.dart';
import 'package:commerce_shop_flutter/components/home/hot_goods.dart';

const APPBAR_SCROLL_OFFSET = 100;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with AutomaticKeepAliveClientMixin {
  List lists = [
    // 轮播图
    HomeSwiper(),
    // 菜单列表
    MenuList(),
    // 新闻资讯
    NewBroadCast(),
    // 热门商品
    HotGoods()
  ];
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context); //必须添加
    return Scaffold(
        body: MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: Stack(
        children: <Widget>[
          ListView.builder(
              itemCount: 4,
              itemBuilder: (BuildContext context, int index) {
                return lists[index];
              })
        ],
      ),
    ));
  }
}
