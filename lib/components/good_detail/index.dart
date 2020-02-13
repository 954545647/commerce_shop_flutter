import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:commerce_shop_flutter/components/common/common_title.dart';
import 'package:commerce_shop_flutter/components/common/good_banner.dart';
import 'dart:convert';

class GoodDetails extends StatefulWidget {
  @override
  _GoodDetailsState createState() => _GoodDetailsState();
}

class _GoodDetailsState extends State<GoodDetails> {
  // 商品图片列表，到时传id去后台获取
  var imageList = [
    'assets/images/potatoes1.webp',
    'assets/images/potatoes2.webp',
    'assets/images/potatoes3.webp',
  ];
  @override
  Widget build(BuildContext context) {
    // 获取路由参数
    var args = ModalRoute.of(context).settings.arguments;
    Map<String, dynamic> argument = json.decode(args);
    return Scaffold(
      body: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: ListView(
          children: <Widget>[
            // 商品标题
            CommonTitle(title: argument['name'].toString()),
            // 商品图片展示
            GoodBanner(
              imageList: imageList,
              height: 400,
            ),
            // 商品价格、简介、销量
            goodDetails(argument),
            // 商品规格（尺码、地址）
            goodSpecification(argument),
            goodEvaluate(argument),
          ],
        ),
      ),
      // 顶部商品展示
    );
  }

  // 商品价格+简介+销量信息
  Widget goodDetails(argument) {
    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          // 商品价格+关注+降价通知
          gooodPrice(argument),
          // 商品简介
          goodDesc(argument),
          // 商品销量
          goodSales(argument)
        ],
      ),
    );
  }

// 商品价格
  Widget gooodPrice(argument) {
    return Container(
      height: ScreenUtil().setHeight(130),
      padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
      // decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text.rich(TextSpan(children: [
            TextSpan(
                text: '￥',
                style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.red,
                    fontWeight: FontWeight.bold)),
            TextSpan(
                text: argument['price'].toString(),
                style: TextStyle(
                    fontSize: 30.0,
                    color: Colors.red,
                    fontWeight: FontWeight.bold))
          ])),
          Container(
            child: Row(
              children: <Widget>[
                InkWell(
                  child: Column(
                    children: <Widget>[
                      Icon(IconData(0xe628, fontFamily: 'myIcons'), size: 22),
                      SizedBox(height: 2),
                      Text('降价通知')
                    ],
                  ),
                ),
                SizedBox(width: 10),
                InkWell(
                    child: Column(
                  children: <Widget>[
                    Icon(IconData(0xe60a, fontFamily: 'myIcons'), size: 22),
                    SizedBox(height: 2),
                    Text('关注')
                  ],
                ))
              ],
            ),
          )
        ],
      ),
    );
  }

  // 商品简介
  Widget goodDesc(argument) {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Text(
        argument['desc'].toString(),
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  // 商品销量
  Widget goodSales(argument) {
    var carriage = argument['carriage'] == 0 ? '免运费' : argument['carriage'];
    return Container(
      height: ScreenUtil().setHeight(80),
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            '快递:$carriage',
            style: TextStyle(color: Color.fromRGBO(139, 133, 133, 1)),
          ),
          Text('月销:${argument['monthlySales']}',
              style: TextStyle(color: Color.fromRGBO(139, 133, 133, 1))),
          Text(argument['yieldly'],
              style: TextStyle(color: Color.fromRGBO(139, 133, 133, 1)))
        ],
      ),
    );
  }

// 商品规格（尺码+地址）
  Widget goodSpecification(argument) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 15, 0, 15),
      height: ScreenUtil().setHeight(240),
      width: ScreenUtil().setWidth(750),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15), color: Colors.white),
      // color: Colors.white,
      child: Container(
          child: Column(
        children: <Widget>[specification(argument), location(argument)],
      )),
    );
  }

// 选择尺码
  Widget specification(argument) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (context) => Container(
            child: ListView(
                children: List.generate(
              2,
              (index) => InkWell(
                  child: Container(
                      alignment: Alignment.center,
                      height: 60.0,
                      child: Text('Item ${index + 1}')),
                  onTap: () {
                    Navigator.pop(context);
                  }),
            )),
            height: 120,
          ),
        );
      },
      child: Container(
        height: ScreenUtil().setHeight(100),
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
                    width: 1, color: Color.fromRGBO(242, 242, 242, 1)))),
        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text('选择', style: TextStyle(color: Colors.grey)),
                  SizedBox(width: 25),
                  Text('尺码 颜色 规格', style: TextStyle(color: Colors.black)),
                ],
              ),
              InkWell(
                child: Icon(Icons.arrow_right),
              )
            ]),
      ),
    );
  }

// 选择地址
  Widget location(argument) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        height: ScreenUtil().setHeight(140),
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
                    width: 1, color: Color.fromRGBO(242, 242, 242, 1)))),
        padding: EdgeInsets.fromLTRB(10, 15, 10, 0),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    height: ScreenUtil().setHeight(150),
                    child: Text('送至', style: TextStyle(color: Colors.grey)),
                  ),
                  SizedBox(width: 25),
                  Container(
                    alignment: Alignment.topCenter,
                    margin: EdgeInsets.only(right: 10),
                    height: ScreenUtil().setHeight(150),
                    child: Icon(IconData(0xe62f, fontFamily: 'myIcons')),
                  ),
                  Container(
                      height: ScreenUtil().setHeight(150),
                      width: ScreenUtil().setWidth(500),
                      child: Text('广东省广州市天河区华南农业大学华山区xx栋',
                          maxLines: 2, overflow: TextOverflow.ellipsis))
                ],
              ),
              InkWell(
                child: Icon(Icons.arrow_right),
              )
            ]),
      ),
    );
  }

// 商品评价（评价+标签+评论）
  Widget goodEvaluate(argument) {
    return Container(
      // height: ScreenUtil().setHeight(250),
      width: ScreenUtil().setWidth(750),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
      ),
      child: Container(
          child: Column(
        children: <Widget>[
          evaluate(argument),
          labels(argument),
          commentList(argument)
        ],
      )),
    );
  }

// 评价
  Widget evaluate(argument) {
    return Container(
      height: ScreenUtil().setHeight(80),
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text('评价', style: TextStyle(color: Colors.black, fontSize: 16)),
                SizedBox(width: 5),
                Text('2100+',
                    style: TextStyle(color: Colors.black, fontSize: 12)),
              ],
            ),
            InkWell(
              onTap: () {
                print('444');
              },
              child: Row(
                children: <Widget>[
                  Text('查看全部', style: TextStyle(color: Colors.grey)),
                  Icon(Icons.arrow_right)
                ],
              ),
            )
          ]),
    );
  }

  // 商品标签
  Widget labels(argument) {
    var labels = ['运行稳定', '兼容性佳', '质量上乘', '方便'];
    return Container(
      height: ScreenUtil().setHeight(60),
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      margin: EdgeInsets.only(bottom: 5),
      child: Row(
          children: labels.map((item) {
        return singleLabels(item);
      }).toList()),
    );
  }

  // 单个标签
  Widget singleLabels(item) {
    return InkWell(
      onTap: () {
        print(item);
      },
      child: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.only(right: 10),
        height: ScreenUtil().setHeight(50),
        width: ScreenUtil().setWidth(150),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Color.fromRGBO(251, 230, 230, 1)),
        child: Text(item),
      ),
    );
  }

  // 用户评论列表
  Widget commentList(argument) {
    return Container(
      // height: ScreenUtil().setHeight(800),
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Column(
        children: <Widget>[
          singleComment(),
          singleComment(),
          seeMore(),
        ],
      ),
    );
  }

// 单个完整评论
  Widget singleComment() {
    return Container(
      child: Column(
        children: <Widget>[
          // 用户头像、姓名、星级
          userInfo(),
          userComment(),
        ],
      ),
    );
  }

// 用户信息
  Widget userInfo() {
    return Container(
      margin: EdgeInsets.only(top: 5),
      child: Row(
        children: <Widget>[
          Image.asset('assets/images/user2.jpg',
              width: ScreenUtil().setWidth(80),
              height: ScreenUtil().setHeight(80)),
          SizedBox(width: 5),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Rex'),
              Row(
                children: <Widget>[
                  Icon(
                    Icons.star,
                    size: 14,
                  ),
                  Icon(
                    Icons.star,
                    size: 14,
                  ),
                  Icon(
                    Icons.star,
                    size: 14,
                  )
                ],
              ),
            ],
          )
        ],
      ),
    );
  }

  // 用户评论带图
  Widget userComment() {
    var imageList = [
      'assets/images/potatoes1.webp',
      'assets/images/user2.jpg',
      'assets/images/potatoes3.webp',
      'assets/images/user2.jpg',
    ];
    return Container(
      // height: ScreenUtil().setHeight(200),
      child: Column(
        children: <Widget>[
          Text(
            'UI界面真难写！！UI界面真难写！！UI界面真难写！！UI界面真难写！！UI界面真难写！！',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          Container(
            height: ScreenUtil().setHeight(200),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: imageList.map((item) {
                return singleImage(item);
              }).toList(),
            ),
          )
        ],
      ),
    );
  }

  // 单个图片
  Widget singleImage(item) {
    return Container(
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(border: Border.all(width: 1)),
      child: new Image.asset(
        item,
        height: ScreenUtil().setHeight(80),
        width: ScreenUtil().setWidth(180),
        fit: BoxFit.fill,
      ),
    );
  }

  // 查看全部评价
  Widget seeMore() {
    return Container(
      height: ScreenUtil().setHeight(60),
      margin: EdgeInsets.fromLTRB(0, 10, 0, 20),
      child: Container(
        alignment: Alignment.center,
        width: ScreenUtil().setWidth(220),
        decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.grey),
            borderRadius: BorderRadius.circular(10)),
        child: Text(
          '查看全部评价',
          style: TextStyle(
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
