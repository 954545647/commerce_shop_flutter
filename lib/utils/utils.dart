// 解析时间，返回 YYYY-MM-DD格式
String parseTime(DateTime time) {
  // time.month =time
  var month = time.month.toString();
  month = month.toString().padLeft(2, "0");
  var day = time.day.toString();
  day = day.toString().padLeft(2, "0");
  return "${time.year}" + "-" + "$month" + "-" + "$day";
}

// 把 createdAt 字段裁剪出 YYYY-MM-DD格式
List parseTimeList(List list) {
  List result = [];
  for (var item in list) {
    if (item["source"] == 1) {
      var str = item["createdAt"].toString().substring(0, 10);
      result.add(str);
    }
  }
  return result;
}

// 截取时间的前10位
String parseSingleTime(String time) {
  var str = time.toString().substring(0, 10);
  return str;
}

// 截取详细时间
String parseDetailTime(String time) {
  String str1 = time.toString().substring(0, 10);
  String str2 = time.toString().substring(11, 19);
  return "$str1 $str2";
}

// 设置过期时间
String pastTime(String time) {
  DateTime curTime = DateTime.parse("$time");
  DateTime newTime = curTime.add(new Duration(minutes: 5));
  String str1 = newTime.toString().substring(0, 10);
  String str2 = newTime.toString().substring(11, 19);
  return "$str1 $str2";
}

// 判断积分来源
String judgeIntegralSource(int source) {
  if (source == 1) {
    return "签到";
  } else if (source == 2) {
    return "下单";
  } else if (source == 3) {
    return "评价";
  } else {
    return "兑换商品";
  }
}

// 积分来源对应的分值
String sourcePoint(int source) {
  if (source == 1) {
    return "+1";
  } else if (source == 2) {
    return "+10";
  } else if (source == 3) {
    return "+5";
  } else {
    return "-$source";
  }
}

// 切割图片路径
String cutPath(String imgCover) {
  imgCover = imgCover.toString();
  if (imgCover.indexOf("10.0.2.2") != -1) {
    imgCover = imgCover.substring(15);
  }
  if (imgCover.indexOf("127.0.0") != -1) {
    imgCover = imgCover.substring(15);
  }
  if (imgCover.indexOf("47.96") != -1) {
    imgCover = imgCover.substring(15);
  }
  return imgCover;
}

// 获取消息的时间
String getMessTime(String time) {
  String detail = time.substring(11, 13);
  time = parseSingleTime(time);
  // 解析传入的时间
  DateTime curTime = DateTime.parse("$time");
  // 当前时间
  DateTime now = new DateTime.now();
  // 计算当前时间和传入时间的差值
  var difference = now.difference(curTime);
  int day = difference.inDays;
  if (day == 0) {
    // 计算是早上还是晚上
    if (int.parse(detail) > 12) {
      return "下午";
    } else {
      return "上午";
    }
  } else if (day == 1) {
    return "昨天";
  } else if (day <= 7) {
    return pasreWeekDay(curTime);
  }
  return time;
}

// 获取当前是星期几
String pasreWeekDay(DateTime time) {
  int weekday = time.weekday;
  String str = "";
  switch (weekday) {
    case 1:
      str = "星期一";
      break;
    case 2:
      str = "星期二";
      break;
    case 3:
      str = "星期三";
      break;
    case 4:
      str = "星期四";
      break;
    case 5:
      str = "星期五";
      break;
    case 6:
      str = "星期六";
      break;
    case 7:
      str = "星期日";
      break;
  }
  return str;
}
