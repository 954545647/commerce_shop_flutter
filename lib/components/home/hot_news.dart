// 热点新闻
import 'package:flutter/material.dart';
import 'package:commerce_shop_flutter/components/common/top_title.dart';
// import 'package:flutter_custom_calendar/flutter_custom_calendar.dart';
// import 'package:commerce_shop_flutter/utils/dio.dart';
import 'package:commerce_shop_flutter/utils/http.dart';

class HotNews extends StatefulWidget {
  @override
  _HotNewsState createState() => _HotNewsState();
}

class _HotNewsState extends State<HotNews> {
  List news = [];
  @override
  void initState() {
    super.initState();
    getData("news").then((val) {
      if (val != null &&
          val["extend"] != null &&
          val["extend"]["news"] != null) {
        setState(() {
          news = val["extend"]["news"];
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: ListView(
          children: <Widget>[
            // 标题
            TopTitle(title: '热点新闻', showArrow: true),
            // 新闻详情
            newslist(),
          ],
        ),
      ),
      // 顶部商品展示
    );
  }

  Widget newslist() {
    if (news.length > 0) {
      return Container(
        child: Column(
          children: news.map((item) {
            return newsItem(item);
          }).toList(),
        ),
      );
    } else {
      return CircularProgressIndicator();
    }
  }

  Widget newsItem(data) {
    var title = data['title'];
    var content = data['content'];
    var date = data['date'];
    var cover = data['cover'];
    print(content is String);
    content = content.replaceAll("\r\n", "");
    return GestureDetector(
      child: Container(
        height: 180,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(border: Border.all(width: 1)),
        child: Row(
          children: <Widget>[
            Container(
              width: 200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    data["title"],
                    style: TextStyle(fontSize: 20),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Text(data["date"])
                ],
              ),
            ),
            Expanded(
              child: Image.network(
                data["cover"],
                fit: BoxFit.fill,
              ),
            )
          ],
        ),
      ),
      onTap: () {
        Navigator.pushNamed(context, 'newsDetail',
            arguments:
                '{"title":"$title","content":"$content","date":"$date","cover":"$cover"}');
      },
    );
  }
}
