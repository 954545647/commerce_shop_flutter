import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
            onTap: () {},
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
    onTap: () {},
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
