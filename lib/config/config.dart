// 基础路由
const BASEURL = 'http://10.0.2.2:3000/';
const BASEURL2 = 'https://greenadoption.cn/';
enum Env {
  PROD,
  DEV,
  LOCAL,
}

class Config {
  static Env env;

  static String get apiHost {
    switch (env) {
      // 生产环境
      case Env.PROD:
        return "http://47.96.96.127/";
      // 开发环境
      case Env.DEV:
        return "http://10.0.2.2:3000/";
      default:
        return "http://10.0.2.2:3000/";
    }
  }
}
