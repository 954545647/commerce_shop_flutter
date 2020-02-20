main() {
  Map<String, List> orderInfo = new Map();
  orderInfo["1"] = [
    {"name": "rex", "age": 18}
  ];
  orderInfo["2"] = [
    {"name": "rex", "age": 18}
  ];
  if (orderInfo.containsKey("1")) {
    print("有");
    var curItem = orderInfo["1"];
    print(curItem);
    curItem.add({"name": "rex", "age": 182});
  } else {
    print("无");
  }
  orderInfo.values.toList().forEach((item) {
    print(item);
  });
}
