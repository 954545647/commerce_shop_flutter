import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:commerce_shop_flutter/config/config.dart';
import 'package:commerce_shop_flutter/config/serviceUrl.dart';

class DioUtils {
  static DioUtils _instance;
  Dio _dio;
  BaseOptions _baseOptions;
  bool isClient = false; // 是顾客业务
  // 获取DIO实例
  static DioUtils getInstance() {
    if (_instance == null) {
      _instance = new DioUtils();
    }
    return _instance;
  }

  // dio 初始化配置
  DioUtils() {
    print("我DIO初始化");
    print("isClient$isClient");
    //请求参数配置
    _baseOptions = new BaseOptions(
      baseUrl: BASEURL,
      connectTimeout: 5000,
      receiveTimeout: 5000,
      headers: {
        //预设好的header信息
      },
    );

    //创建dio实例
    _dio = new Dio(_baseOptions);

    //请求拦截器
    _dio.interceptors.add(
      InterceptorsWrapper(onRequest: (RequestOptions requestions) async {
        // 从本地缓存中读取token
        var token = await getToken();
        if (token != null) {
          requestions.headers.addAll({"Authorization": "Bearer " + token});
        }
        // print('-----请求参数--' + requestions.headers.toString());
        return requestions;
      }, onResponse: (Response response) {
        //此处拦截工作在数据返回之后，可在此对dio请求的数据做二次封装或者转实体类等相关操作
        return response;
      }, onError: (DioError error) {
        //处理错误请求
        return error;
      }),
    );
  }

  // get请求
  get(url, {data, options}) async {
    // print('get request path ------$url-------请求参数$data');
    Response response;
    isClient = url[0] == "S" ? false : true;
    try {
      response =
          await _dio.get(urlList[url], queryParameters: data, options: options);
      // print('请求路径---$url------请求结果--------${response.data}\n\n');
      return response.data;
    } on DioError catch (e) {
      print('请求失败---错误类型${e.type}--错误信息${e.message}');
    }
  }

  // post请求
  post(url, {data, options}) async {
    // print('post request path ------$url-------请求参数$data');
    isClient = url[0] == "S" ? false : true;
    Response response;
    try {
      response = await _dio.post(urlList[url], data: data, options: options);
      // print('请求路径---$url------请求结果-----${response.data}\n\n');
      return response.data;
    } on DioError catch (e) {
      print('请求失败---错误类型${e.type}--错误信息${e.message}');
    }
  }

  // 获取token
  getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = isClient ? prefs.get("token") : prefs.get("stoken");
    if (token != null && token.length == 0) {
      return "";
    }
    return token;
  }
}

// 封装通用接口
Future getData(url, {data, String baseUrl: BASEURL2}) async {
  try {
    Response response;
    Dio dio = new Dio();
    url = baseUrl + url;
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
