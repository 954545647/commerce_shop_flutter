import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:commerce_shop_flutter/components/home/HomeSwiper.dart';
import 'package:commerce_shop_flutter/components/home/MenuList.dart';
import 'package:commerce_shop_flutter/components/home/NewBroadCast.dart';
import 'package:commerce_shop_flutter/components/home/HotGoods.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context); //必须添加
    return Container(
        child: Scaffold(
            appBar: AppBar(
              title: Text('绿色农场'),
            ),
            body: EasyRefresh(
              // header: SpaceHeader(key: _headerKey),
              child: ListView(
                children: <Widget>[
                  Column(children: <Widget>[
                    // 轮播图
                    HomeSwiper(),
                    // 菜单列表
                    MenuList(),
                    // 新闻资讯
                    NewBroadCast(),
                    // 热门商品
                    HotGoods()
                  ])
                ],
              ),
              onRefresh: () async {
                print('上拉');
              },
              onLoad: () async {
                print('下拉加载更多');
              },
            )));
  }
}
