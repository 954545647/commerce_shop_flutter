import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:commerce_shop_flutter/components/common/menuIcon.dart';

class MenuList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil.getInstance().setWidth(750),
      height: ScreenUtil.getInstance().setHeight(310),
      child: GridView.count(
        physics: NeverScrollableScrollPhysics(), // 禁止回弹
        crossAxisCount: 5,
        padding: EdgeInsets.symmetric(vertical: 0),
        children: menuListData.map((item) => menuListItem(item)).toList(),
      ),
    );
  }

// 菜单列表单独子项
  Widget menuListItem(data) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(bottom: 10.0),
      child: Column(
        children: <Widget>[
          Expanded(
            child: GestureDetector(
              onTap: () {
                print('4444');
              },
              child: data.icon,
            ),
          ),
          Text(data.title,
              style: TextStyle(fontSize: 13, color: Color(0xFF333333))),
        ],
      ),
    );
  }
}

class MenuListItemViewModel {
  /// 图标
  final Icon icon;

  /// 标题
  final String title;

  const MenuListItemViewModel({
    this.icon,
    this.title,
  });
}


/// 美团 - 服务菜单
const List<MenuListItemViewModel> menuListData = [
  MenuListItemViewModel(
    title: '实时监控',
    icon: Icon(
      MenuIcons.monitoring,
      size: 25,
      color: Colors.lightBlue,
    ),
  ),
  MenuListItemViewModel(
    title: '租地种植',
    icon: Icon(
      MenuIcons.farm,
      size: 25,
      color: Colors.orangeAccent,
    ),
  ),
  MenuListItemViewModel(
    title: '畜牧认养',
    icon: Icon(
      MenuIcons.adoptionMarket,
      size: 29,
      color: Colors.deepOrangeAccent,
    ),
  ),
  MenuListItemViewModel(
    title: '附近农场',
    icon: Icon(
      MenuIcons.nearFarm,
      size: 29,
      color: Colors.deepOrangeAccent,
    ),
  ),
  MenuListItemViewModel(
    title: '拼团商城',
    icon: Icon(
      MenuIcons.assemble,
      size: 29,
      color: Colors.deepOrangeAccent,
    ),
  ),
  MenuListItemViewModel(
    title: '每日签到',
    icon: Icon(
      MenuIcons.signIn,
      size: 29,
      color: Colors.deepOrangeAccent,
    ),
  ),
  MenuListItemViewModel(
    title: '积分商城',
    icon: Icon(
      MenuIcons.integralShop,
      size: 29,
      color: Colors.deepOrangeAccent,
    ),
  ),
  MenuListItemViewModel(
    title: '热点新闻',
    icon: Icon(
      MenuIcons.hotNews,
      size: 29,
      color: Colors.deepOrangeAccent,
    ),
  ),
  MenuListItemViewModel(
    title: '领劵中心',
    icon: Icon(
      MenuIcons.coupon,
      size: 29,
      color: Colors.deepOrangeAccent,
    ),
  ),
  MenuListItemViewModel(
    title: '客服中心',
    icon: Icon(
      MenuIcons.customerService,
      size: 29,
      color: Colors.deepOrangeAccent,
    ),
  ),
];