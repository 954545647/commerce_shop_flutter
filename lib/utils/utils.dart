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
    var str = item["createdAt"].toString().substring(0, 10);
    result.add(str);
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
