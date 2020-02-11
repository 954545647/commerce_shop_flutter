String parseTime(DateTime time) {
  // time.month =time
  var month = time.month.toString();
  month = month.toString().padLeft(2, "0");
  var day = time.day.toString();
  day = day.toString().padLeft(2, "0");
  return "${time.year}" + "-" + "$month" + "-" + "$day";
}

List parseTimeList(List list) {
  List result = [];
  for (var item in list) {
    var str = item["createdAt"].toString().substring(0, 10);
    result.add(str);
  }
  return result;
}
