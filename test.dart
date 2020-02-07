import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart'; // ios风格
import 'package:commerce_shop_flutter/pages/home.dart';
import 'package:commerce_shop_flutter/pages/market.dart';
import 'package:commerce_shop_flutter/pages/user_center.dart';
import 'package:commerce_shop_flutter/pages/rent_land.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class IndexPage extends StatefulWidget {
  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage>
    with SingleTickerProviderStateMixin {
  // 底部导航图标列表
  // final List<BottomNavigationBarItem> _bottomList = [
  //   BottomNavigationBarItem(icon: Icon(CupertinoIcons.home), title: Text('首页')),
  //   BottomNavigationBarItem(
  //       icon: Icon(CupertinoIcons.location), title: Text('租地')),
  //   BottomNavigationBarItem(
  //       icon: Icon(CupertinoIcons.shopping_cart), title: Text('认养')),
  //   BottomNavigationBarItem(
  //       icon: Icon(CupertinoIcons.profile_circled), title: Text('我的')),
  // ];

  TabController _tabController; //需要定义一个Controller
  List tabs = ["首页", "租地", "认养", "我的"];
  // 页面列表
  final List<Widget> tabPages = [
    Home(), // 首页
    RentLand(), // 租赁页面
    Market(), // 集市页面
    UserCenter(), // 个人中心页面
  ];

  int _currentIndex = 0; // 当前索引
  var currentPage; // 当前页面

  @override
  void initState() {
    super.initState();
    // 初始化：变量设定默认为首页
    _tabController = TabController(length: tabs.length, vsync: this);
    currentPage = tabPages[_currentIndex];
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance =
        ScreenUtil(width: 750, height: 1334, allowFontScaling: true)
          ..init(context);
    return Scaffold(
        appBar: AppBar(
          bottom: TabBar(
              controller: _tabController,
              tabs: tabs.map((e) => Tab(text: e)).toList()),
        ),
        backgroundColor: Color.fromARGB(244, 245, 245, 1),
        // body: tabPages[_currentIndex],
        // body: IndexedStack(
        //   index: _currentIndex,
        //   children: tabPages,
        // ),
        body: TabBarView(
          controller: _tabController,
          children: tabs.map((e) {
            //创建3个Tab页
            return Container(
              alignment: Alignment.center,
              child: Text(e, textScaleFactor: 5),
            );
          }).toList(),
        ));
  }
}
