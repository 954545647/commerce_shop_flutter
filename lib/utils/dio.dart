import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:commerce_shop_flutter/config/config.dart';
import 'package:commerce_shop_flutter/config/serviceUrl.dart';
import 'dart:convert';
import 'package:commerce_shop_flutter/components/common/toast.dart';
import 'package:flutter/material.dart';

class DioUtil {
  Dio _dio;
  BaseOptions _baseOptions;
  static DioUtil _instance;
  bool isClient = false; // 是顾客业务
  var curData; // 访问当前路由携带的参数
  var curOptions; // 访问当前路由携带的配置
  BuildContext context;
  bool type; // 默认true代表get请求

  // 获取DIO实例
  static DioUtil getInstance(context) {
    if (_instance == null) {
      _instance = new DioUtil();
    }
    _instance.context = context;
    return _instance;
  }

  // dio 初始化配置
  DioUtil() {
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

    //拦截器
    _dio.interceptors.add(
      // 请求拦截器：添加token
      InterceptorsWrapper(onRequest: (RequestOptions requestions) async {
        // 从本地缓存中读取token
        var token = await getToken();
        if (token != null) {
          requestions.headers.addAll({"Authorization": "Bearer " + token});
        }
        return requestions;
      }, onResponse: (Response response) {
        // 响应拦截器
        return response;
      }, onError: (DioError error) async {
        int errorCode = error.response.data["errorCode"];
        // accessToken 过期
        if (errorCode == 10006) {
          // 重新获取
          Dio dio = DioUtil()._dio; //获取Dio单例
          dio.lock(); // 加锁
          // 根据 refreshToken 去刷新 accessToken
          String accessToken = await getAccessToken();
          // 重新发起一个当前请求，携带新accessToken去获取数据
          Dio tokenDio = new Dio(); //创建新的Dio实例
          tokenDio.options.headers
              .addAll({"Authorization": "Bearer " + accessToken});
          try {
            // 重新访问的路径
            String path = error.response.data["path"];
            var newRequest;
            if (type) {
              newRequest = await tokenDio.post("${Config.apiHost}$path",
                  data: curData, options: curOptions);
            } else {
              newRequest = await tokenDio.get("${Config.apiHost}$path",
                  options: curOptions);
            }
            print("$error,$errorCode,$accessToken,$path,$newRequest");
            // 解锁
            dio.unlock();
            return newRequest;
          } on DioError catch (e) {
            return e;
          }
        }
        return error;
      }),
    );
  }

  // get请求
  get(url, {data, options}) async {
    Response response;
    type = false;
    isClient = url[0] == "S" ? false : true;
    curData = data;
    curOptions = options;
    try {
      response =
          await _dio.get(urlList[url], queryParameters: data, options: options);
      return response.data;
    } on DioError catch (e) {
      print('请求失败---错误类型${e.type}--错误信息${e.message}');
    }
  }

  // post请求
  post(url, {data, options}) async {
    Response response;
    type = true;
    isClient = url[0] == "S" ? false : true;
    curData = data;
    curOptions = options;
    // print("当前路由${urlList[url]}当前携带数据$data当前携带配置$options");
    try {
      response = await _dio.post(urlList[url], data: data, options: options);
      return response.data;
    } on DioError catch (e) {
      if (e.response != null) {
        return jsonDecode(e.response.toString());
      } else {
        print('请求失败---错误类型${e.type}--错误信息${e.message}');
      }
    }
  }

  // 获取token
  getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token =
        isClient ? prefs.get("accessToken") : prefs.get("SaccessToken");
    if (token != null && token.length == 0) {
      return "";
    }
    return token;
  }

  getAccessToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String refreshToken =
        isClient ? prefs.get("refreshToken") : prefs.get("SrefreshToken");
    // 获取 refreshToken (在登录的时候保存的)
    String accessToken;
    Dio dio = new Dio();
    dio.options.headers.addAll({"Authorization": "Bearer " + refreshToken});
    try {
      //请求refreshToken刷新的接口路由
      String url = "${Config.apiHost}/utils/getRefreshToken";
      var response = await dio.post(url);
      var data = response.data["data"];
      accessToken = data['accessToken']; //新的accessToken
      refreshToken = data['refreshToken']; //新的refreshToken
      if (isClient) {
        // 更新顾客的token
        prefs.setString("accessToken", accessToken); //保存顾客新的accessToken
        prefs.setString("refreshToken", refreshToken); //保存顾客新的refreshToken
      } else {
        // 更新商家的token
        prefs.setString("SaccessToken", accessToken); //保存商家新的accessToken
        prefs.setString("SrefreshToken", refreshToken); //保存商家新的refreshToken
      }
    } on DioError catch (error) {
      int errorCode = error.response.data["errorCode"];
      // refreshToken 过期
      if (errorCode == 10007) {
        Future.delayed(Duration(seconds: 1), () async {
          Toast.toast(_instance.context, msg: "太久没登录，请重新登录！", showTime: 2000);
          // 跳转登录页面
          Navigator.pushNamed(_instance.context, "login");
        });
      }
    }
    return accessToken;
  }
}

// 封装通用接口
Future getData(url, {data, String baseUrl: BASEURL2}) async {
  try {
    Response response;
    Dio dio = new Dio();
    url = baseUrl + "/" + url;
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

//refreshToken过期，弹出登录页面
//解决方法一：封装一个全局的context
//return Navigator.of(Util.context).push(new MaterialPageRoute( builder: (ctx) => new LoginPage()))；
//解决方法二：当refresh token过期，把退出的登录的操作放在dio网络请求的工具类去操作
