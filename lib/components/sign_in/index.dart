// 签到页面
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:commerce_shop_flutter/components/common/common_title.dart';
import 'package:commerce_shop_flutter/components/common/toast.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:commerce_shop_flutter/utils/utils.dart';
import 'package:commerce_shop_flutter/utils/dio.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  DateTime _selectDate = DateTime.now();
  DateTime _currentDate = DateTime.now();
  List signDays = [];
  @override
  void initState() {
    super.initState();
    getUserSignData().then((val) {
      setState(() {
        signDays = val;
      });
    });
  }

// 获取用户签到日期 返回的是一个 Future对象
  getUserSignData() async {
    var data = await DioUtil.getInstance(context).post('getUserSignDays');
    return parseTimeList(data["data"]);
  }

// 修改积分
  void modifyIntegral() async {
    var data = await DioUtil.getInstance(context)
        .post("changeIntegral", data: {"source": 1});
    if (data == null) {
      Toast.toast(context, msg: "修改失败");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: ListView(
          children: <Widget>[
            // 商品标题
            CommonTitle(title: '农场签到'),
            // 签到板
            signInBanner(),
            cal(),
          ],
        ),
      ),
      // 顶部商品展示
    );
  }

  // 签到板
  Widget signInBanner() {
    return Container(
      height: ScreenUtil().setHeight(350),
      // decoration: BoxDecoration(border: Border.all(color: Colors.red)),
      padding: EdgeInsets.only(top: 30),
      child: Column(
        children: <Widget>[
          // 签到按钮
          signButton(),
        ],
      ),
    );
  }

  // 签到按钮
  Widget signButton() {
    return GestureDetector(
      onTap: () {
        // Navigator.pushNamed(context, 'integralMall');
        // 调接口，将当前日期保存到已经签到数组中去
        setState(() {
          if (signDays.indexOf(parseTime(_currentDate)) == -1) {
            signDays.add(parseTime(_currentDate));
            // 修改积分
            modifyIntegral();
          } else {
            Toast.toast(context, msg: "已经签到啦");
          }
        });
      },
      child: Container(
        height: ScreenUtil().setHeight(240),
        width: ScreenUtil().setWidth(240),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: Color.fromRGBO(228, 231, 238, 1)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.date_range),
            SizedBox(height: 10),
            Text('签到'),
            SizedBox(height: 10),
            Text(
              '${_currentDate.month.toString()}/${_currentDate.day.toString()}',
              style: TextStyle(color: Colors.grey),
            )
          ],
        ),
      ),
    );
  }

  // 日历
  Widget cal() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.0),
      child: CalendarCarousel(
        onDayPressed: (DateTime date, List events) {
          this.setState(() {
            _selectDate = date;
          });
        },
        onCalendarChanged: (DateTime date) {},
        // 日常文字颜色
        daysTextStyle: TextStyle(color: Colors.black),
        // 周末颜色
        weekendTextStyle: TextStyle(
          color: Colors.black,
        ),
        // 隐藏非当前月的日子
        prevDaysTextStyle: TextStyle(color: Colors.white),
        nextDaysTextStyle: TextStyle(color: Colors.white),
        // 被选中按钮的颜色
        selectedDayButtonColor: Colors.red,
        // 被选中按钮边框的颜色
        selectedDayBorderColor: Colors.transparent,
        selectedDayTextStyle: TextStyle(color: Colors.white),
        // 日历头部的字体
        headerTextStyle: TextStyle(
            color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
        // 日历头部左右两个箭头
        iconColor: Colors.black,
        // 工作日字体颜色
        weekdayTextStyle: TextStyle(color: Color.fromRGBO(172, 170, 170, 1)),
        // 当天按钮的颜色
        todayButtonColor: Color.fromRGBO(203, 209, 215, 1),
        //当天按钮边框的颜色
        todayBorderColor: Colors.transparent,
        // 当前月所有按钮的边框颜色
        thisMonthDayBorderColor: Colors.transparent,
        customDayBuilder: (
          bool isSelectable,
          int index,
          bool isSelectedDay,
          bool isToday,
          bool isPrevMonthDay,
          TextStyle textStyle,
          bool isNextMonthDay,
          bool isThisMonthDay,
          DateTime day,
        ) {
          String today = parseTime(day);
          if (signDays.indexOf(today) != -1) {
            return Container(
                child: Center(
              child: Icon(
                IconData(0xe648, fontFamily: 'myIcons'),
                size: 24,
              ),
            ));
          } else {
            return null;
          }
        },
        weekFormat: false,
        // markedDatesMap: _markedDateMap,
        height: 420.0,
        selectedDateTime: _selectDate,
        daysHaveCircularBorder: false,
      ),
    );
  }
}
