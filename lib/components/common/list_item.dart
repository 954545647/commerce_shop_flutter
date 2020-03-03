// 常见的列表子项
import 'package:flutter/material.dart';
// import 'package:commerce_shop_flutter/components/common/menuIcon.dart';
import 'package:provider/provider.dart';
import 'package:commerce_shop_flutter/provider/userData.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ListItem extends StatefulWidget {
  ListItem(
      {Key key,
      this.title: "",
      this.jumpRoute: "index",
      this.iconName: "0xe632",
      this.size = 20,
      @required this.onChanged})
      : super(key: key);

  final String title; // 标题
  final onChanged; //
  final String iconName; // 图标
  final String jumpRoute;
  final double size;

  @override
  _ListItemState createState() => new _ListItemState();
}

class _ListItemState extends State<ListItem> {
  @override
  Widget build(BuildContext context) {
    var icon = int.parse(widget.iconName);
    final user = Provider.of<UserData>(context);
    return new GestureDetector(
      child: Container(
        width: ScreenUtil.getInstance().setWidth(100),
        height: ScreenUtil.getInstance().setHeight(100),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(IconData(icon, fontFamily: 'myIcons'), size: widget.size),
            Text(
              widget.title,
              style: TextStyle(fontSize: 16.0),
            )
          ],
        ),
      ),
      onTap: () {
        if (!user.isLogin) {
          Navigator.pushNamed(context, "login");
        } else {
          Navigator.pushNamed(context, widget.jumpRoute);
          widget.onChanged();
        }
      },
    );
  }
}
