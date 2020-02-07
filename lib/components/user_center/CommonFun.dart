import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CommonFun extends StatefulWidget {
  @override
  _CommonFunState createState() => _CommonFunState();
}

class _CommonFunState extends State<CommonFun> {
  List listData = [
    {'funName': '我的地块', 'funDesc': '进入播种或摘取', 'iconName': '0xe67f'},
    {'funName': '我的认养', 'funDesc': '认养实时信息', 'iconName': '0xe613'},
    {'funName': '我的钱包', 'funDesc': '查看余额积分', 'iconName': '0xe609'},
    {'funName': '推广中心', 'funDesc': '邀请好友赚钱', 'iconName': '0xe635'},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.fromLTRB(15, 25, 15, 15),
      width: ScreenUtil().setWidth(750),
      height: ScreenUtil().setHeight(400),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10.0)),
      child: Container(
        padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Text('常用功能',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))
              ],
            ),
            Container(
              width: ScreenUtil.getInstance().setWidth(750),
              height: ScreenUtil().setHeight(280),
              child: GridView.count(
                physics: NeverScrollableScrollPhysics(), // 禁止回弹
                crossAxisCount: 2,
                childAspectRatio: 2.5,
                padding: EdgeInsets.symmetric(vertical: 0),
                children: listData.map((item) => singleFun(item)).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget singleFun(data) {
    var icon = int.parse(data['iconName']);
    return Container(
      decoration: BoxDecoration(
          border: Border(
              right: data['funName'] == '我的地块' || data['funName'] == '我的钱包'
                  ? BorderSide(width: 0)
                  : BorderSide(color: Colors.white),
              bottom: data['funName'] == '我的地块' || data['funName'] == '我的认养'
                  ? BorderSide(width: 0)
                  : BorderSide(color: Colors.white))),
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[Text(data['funName']), Text(data['funDesc'])],
          ),
          Icon(IconData(icon,fontFamily: 'myIcons')),
        ],
      ),
    );
  }
}
