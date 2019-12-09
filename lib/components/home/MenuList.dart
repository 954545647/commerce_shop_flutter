import 'package:flutter/material.dart';
import 'package:commerce_shop_flutter/components/home/menuListData.dart'; // 菜单列表数据
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MenuList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil.getInstance().setWidth(750),
      height: ScreenUtil.getInstance().setHeight(310),
      child: GridView.count(
        physics: NeverScrollableScrollPhysics(),  // 禁止回弹
        crossAxisCount: 5,
        padding: EdgeInsets.symmetric(vertical: 0),
        children: menuListData.map((item) => menuListItem(item)).toList(),
      ),
    );
  }

  Widget menuListItem(data){
        return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(bottom: 10.0),
      child: Column(
        children: <Widget>[
          Expanded(
            child: GestureDetector(
              onTap: (){print('4444');},
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

// 菜单列表单独子项
class MenuListItem extends StatelessWidget {
  final MenuListItemViewModel data;
  MenuListItem({Key key, this.data}) : super(key: key);

  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(bottom: 10.0),
      child: Column(
        children: <Widget>[
          Expanded(
            child: GestureDetector(
              onTap: (){print('4444');},
              child: this.data.icon,
            ),
          ),
          Text(this.data.title,
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
