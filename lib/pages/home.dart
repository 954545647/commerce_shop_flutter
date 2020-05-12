import 'package:flutter/material.dart';
// import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:commerce_shop_flutter/components/home/search_bar.dart';
import 'package:commerce_shop_flutter/components/home/home_swiper.dart';
import 'package:commerce_shop_flutter/components/home/menu_list.dart';
import 'package:commerce_shop_flutter/components/home/weather.dart';
import 'package:commerce_shop_flutter/components/home/hot_adopt.dart';
import 'package:commerce_shop_flutter/components/home/hot_farm.dart';

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
    // 天气预报
    Weather(),
    // 热门认养
    HotAdopt(),
    // 热门租地
    HotFarm(),
  ];
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context); //必须添加
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                showSearch(context: context, delegate: CustomSearchDelegate());
              },
            )
          ],
        ),
        body: MediaQuery.removePadding(
          context: context,
          removeTop: true,
          child: Stack(
            children: <Widget>[
              ListView.builder(
                  itemCount: lists.length,
                  itemBuilder: (BuildContext context, int index) {
                    return lists[index];
                  })
            ],
          ),
        ));
  }
}
