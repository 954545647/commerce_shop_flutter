import 'package:dio/dio.dart';
import 'dart:async';
import 'package:commerce_shop_flutter/config/config.dart';

// 封装通用接口
Future getData(url, {data}) async {
  try {
    Response response;
    Dio dio = new Dio();
    url = BASEURL2 + url;
    if (data == null) {
      // get请求
      response = await dio.get(url);
    } else {
      // post请求
      response = await dio.post(url, data: data);
    }
    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('接口出现异常');
    }
  } catch (e) {
    return print(e);
  }
}
