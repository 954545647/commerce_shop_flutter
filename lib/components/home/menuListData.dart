import 'package:flutter/material.dart';
import 'package:commerce_shop_flutter/components/common/menuIcon.dart';
import 'package:commerce_shop_flutter/components/home/menuList.dart';

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
