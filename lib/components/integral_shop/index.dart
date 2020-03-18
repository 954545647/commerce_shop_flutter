// 积分商城
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:commerce_shop_flutter/components/common/top_title.dart';
import 'package:commerce_shop_flutter/utils/dio.dart';

class IntegralMall extends StatefulWidget {
  @override
  _IntegralMallState createState() => _IntegralMallState();
}

class _IntegralMallState extends State<IntegralMall> {
  int point;
  @override
  void initState() {
    super.initState();
    // 获取用户积分
    DioUtil.getInstance(context).post('getUserInfo').then((val) {
      if (val != null) {
        setState(() {
          point = val["data"]["point"];
        });
      }
    });
    // 获取积分商城数据
  }

  // var imageList = [
  //   'assets/images/potatoes1.webp',
  //   'assets/images/potatoes2.webp',
  //   'assets/images/potatoes3.webp',
  // ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: ListView(
          children: <Widget>[
            // 积分标题
            TopTitle(title: '积分商城', showArrow: true),
            // 积分详情
            intergalDetail(),
            // 商品轮播图
            // GoodBanner(imageList: imageList, height: 300),
            // 积分类型
            intergalType(),
            // 兑换热门商品
            exchangeHotGoods(),
          ],
        ),
      ),
      // 顶部商品展示
    );
  }

  // 积分详情
  Widget intergalDetail() {
    return Container(
      height: ScreenUtil().setHeight(100),
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(width: 1, color: Colors.grey))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: intergalData(),
          ),
          Expanded(
            child: exchangeRecord(),
          )
        ],
      ),
    );
  }

  // 积分数据
  Widget intergalData() {
    return Container(
      height: 100.0,
      decoration: BoxDecoration(
          border: Border(
              right: BorderSide(color: Color.fromRGBO(224, 222, 222, 1)))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.data_usage),
          Padding(
            padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
            child: Text('积分'),
          ),
          Text(point.toString())
        ],
      ),
    );
  }

  // 兑换记录
  Widget exchangeRecord() {
    return GestureDetector(
      child: Container(
        height: 100.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.data_usage),
            Padding(
              padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
              child: Text('兑换记录'),
            )
          ],
        ),
      ),
      onTap: () {
        Navigator.pushNamed(context, "integralDetail");
      },
    );
  }

// 积分种类
  Widget intergalType() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
      margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Column(
            children: <Widget>[
              Container(
                height: ScreenUtil().setHeight(150),
                width: ScreenUtil().setWidth(150),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: AssetImage('assets/images/poultry.jpg'),
                        fit: BoxFit.cover)),
              ),
              Text('家禽')
            ],
          ),
          Column(
            children: <Widget>[
              Container(
                height: ScreenUtil().setHeight(150),
                width: ScreenUtil().setWidth(150),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: AssetImage('assets/images/vegetable.jpg'),
                        fit: BoxFit.cover)),
              ),
              Text('蔬菜')
            ],
          ),
          Column(
            children: <Widget>[
              Container(
                height: ScreenUtil().setHeight(150),
                width: ScreenUtil().setWidth(150),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: AssetImage('assets/images/fruit.jpeg'),
                        fit: BoxFit.cover)),
              ),
              Text('水果')
            ],
          ),
          Column(
            children: <Widget>[
              Container(
                height: ScreenUtil().setHeight(150),
                width: ScreenUtil().setWidth(150),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: AssetImage('assets/images/potatoes1.webp'),
                        fit: BoxFit.cover)),
              ),
              Text('其他')
            ],
          )
        ],
      ),
    );
  }

// 兑换热门商品
  Widget exchangeHotGoods() {
    var goodList = [
      {
        'imgUrl': 'assets/images/potatoes1.webp',
        'title': '土豆',
        'integral': '100'
      },
      {
        'imgUrl': 'assets/images/potatoes1.webp',
        'title': '土豆',
        'integral': '200'
      },
      {
        'imgUrl': 'assets/images/potatoes1.webp',
        'title': '土豆',
        'integral': '70'
      },
      {
        'imgUrl': 'assets/images/potatoes1.webp',
        'title': '土豆',
        'integral': '70'
      },
    ];
    return Container(
      color: Color.fromRGBO(240, 237, 236, 1),
      child: Column(
        children: <Widget>[
          // 兑换标题
          Container(
            color: Colors.white,
            alignment: Alignment.center,
            height: ScreenUtil().setHeight(100),
            child: Text('兑换热品'),
          ),
          // 兑换商品
          Container(
            padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
            child: GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              crossAxisSpacing: 10, // 水平间距10
              mainAxisSpacing: 10, // 垂直间距10
              physics: NeverScrollableScrollPhysics(), // 禁止回弹
              childAspectRatio: 1,
              children: goodList.map((item) => hotGoods(item)).toList(),
            ),
          )
        ],
      ),
    );
  }

// 热门商品
  Widget hotGoods(data) {
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      // margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Image.asset(
            data['imgUrl'],
            height: ScreenUtil().setHeight(250),
            fit: BoxFit.fill,
          ),
          Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                child: Text(data['title']),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(15, 0, 0, 5),
                child: Text.rich(TextSpan(children: [
                  TextSpan(
                      text: data['integral'],
                      style: TextStyle(
                          fontSize: 16.0,
                          color: Color.fromRGBO(109, 162, 114, 1),
                          fontWeight: FontWeight.bold)),
                  TextSpan(
                      text: '积分',
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.grey,
                      ))
                ])),
              )
            ],
          )
        ],
      ),
    );
  }
}
