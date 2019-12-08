
// 管理登录状态
class AuthState {
  bool isLogin = false; //是否登录
  String userName; //用户名
  String password; //密码
}

class AppState {
  AuthState auth; // 登录
  AppState({this.auth});
}
