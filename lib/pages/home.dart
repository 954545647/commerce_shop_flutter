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

// 添加顶部导航栏

// class Home extends StatefulWidget {
//   @override
//   _HomeState createState() => _HomeState();
// }

// class _HomeState extends State<Home> with AutomaticKeepAliveClientMixin {
//   @override
//   bool get wantKeepAlive => true;
//   double _homepageOpacity = 0;

//   _onScroll(offset) {
//     double alpha = offset / APPBAR_SCROLL_OFFSET;
//     if (alpha < 0) {
//       alpha = 0;
//     } else if (alpha > 1) {
//       alpha = 1;
//     }
//     setState(() {
//       _homepageOpacity = alpha;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     super.build(context); //必须添加
//     return Scaffold(
//         body: MediaQuery.removePadding(
//       context: context,
//       removeTop: true,
//       child: Stack(
//         children: <Widget>[
//           NotificationListener(
//             onNotification: (scrollNotification) {
//               if (scrollNotification is ScrollUpdateNotification &&
//                   scrollNotification.depth == 0) {
//                 _onScroll(scrollNotification.metrics.pixels);
//               }
//               return true;
//             },
//             // child: EasyRefresh(
//             // header: SpaceHeader(key: _headerKey),
//             child: ListView(
//               children: <Widget>[
//                 Column(children: <Widget>[
//                   // 轮播图
//                   HomeSwiper(),
//                   // 菜单列表
//                   MenuList(),
//                   // 新闻资讯
//                   NewBroadCast(),
//                   // 热门商品
//                   HotGoods()
//                 ])
//               ],
//             ),
//             // onRefresh: () async {
//             //   print('上拉');
//             // },
//             // onLoad: () async {
//             //   print('下拉加载更多');
//             // },
//             // ),
//           ),
//           Opacity(
//             opacity: _homepageOpacity,
//             child: Container(
//               height: 80,
//               decoration: BoxDecoration(color: Colors.white),
//               child: Center(
//                 child: Padding(
//                   padding: EdgeInsets.only(top: 20),
//                   child: Text('绿色认养'),
//                 ),
//               ),
//             ),
//           )
//         ],
//       ),
//     ));
//   }
// }
