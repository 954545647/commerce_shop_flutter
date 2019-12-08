enum MyActions {
  Login,
  LoginSuccess,
  LogoutSuccess
}

// 定义所有action的基类
class Action {
  MyActions type;
  Action({this.type});
}

// 定义成功的action
class LoginSuccessAction extends Action {
  final String userName;
  final String password;
  LoginSuccessAction({this.userName,this.password}) : super(type: MyActions.LoginSuccess);
}
