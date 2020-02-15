// 热点新闻-->新闻详情
import 'package:flutter/material.dart';
import 'package:commerce_shop_flutter/components/common/top_title.dart';
import 'dart:convert';

class NewDetails extends StatelessWidget {
  // final data;
  // NewDetails({this.data});
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
            // 标题
            TopTitle(title: '新闻详情', showArrow: true),
            Container(
                padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                height: 100,
                alignment: Alignment.center,
                child: Text(
                  argument["title"],
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 20),
                )),
            Image.network(
              argument["cover"],
              fit: BoxFit.cover,
              width: 500,
              height: 200,
            ),
            SizedBox(height: 20),
            Container(
              child: Text(
                argument["content"],
                style: TextStyle(fontSize: 20),
              ),
            )
          ],
        ),
      ),
    );
  }
}
