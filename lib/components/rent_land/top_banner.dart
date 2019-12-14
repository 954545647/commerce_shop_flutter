import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:commerce_shop_flutter/config/service_method.dart';
import 'package:commerce_shop_flutter/components/common/top_title.dart';

class TopBanner extends StatefulWidget {
  @override
  _TopBannerState createState() => _TopBannerState();
}

class _TopBannerState extends State<TopBanner> {
  var list = []; // 滚动城市列表
  var _currrentIndex = 0; //当前选中城市
  @override
  void initState() {
    super.initState();
    getData('leftList').then((val) {
      setState(() {
        list = val['data']['menuList'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          // 顶部标题
          TopTitle(title: '租地'),
          // 顶部滚动条
          _bannerScroll()
        ],
      ),
    );
  }

// 顶部滚动条组件
  Widget _bannerScroll() {
    return Container(
      height: ScreenUtil().setHeight(100),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: list.length,
        itemBuilder: (BuildContext context, int index) {
          return _singleBannerItem(index);
        },
      ),
    );
  }

// 顶部滚动子项
  Widget _singleBannerItem(int index) {
    return InkWell(
      onTap: () {
        setState(() {
          _currrentIndex = index;
        });
      },
      child: Container(
        alignment: Alignment.center,
        width: ScreenUtil().setWidth(150),
        decoration: BoxDecoration(
          border: Border(
              bottom: _currrentIndex == index
                  ? BorderSide(width: 1)
                  : BorderSide(width: 0)),
          color: Colors.white,
        ),
        child: Text(list[index]),
      ),
    );
  }
}
