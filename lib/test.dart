import "package:commerce_shop_flutter/utils/utils.dart";

void main(List<String> args) {
  String str = "2020-03-07 21:03:04";
  String str1 = "2020-03-09 21:03:04";
  String str2 = "2020-03-10 21:03:04";
  String str3 = "2020-03-11 21:03:04";
  print(str.substring(11, 13));
  str = getMessTime(str);
  str1 = getMessTime(str1);
  str2 = getMessTime(str2);
  str3 = getMessTime(str3);
  print(str);
  print(str1);
  print(str2);
  print(str3);
}
