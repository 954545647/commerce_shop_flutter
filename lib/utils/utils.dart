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

String parseSingleTime(String time) {
  var str = time.toString().substring(0, 10);
  return str;
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
