import 'package:commerce_shop_flutter/model/actions.dart';
import 'package:commerce_shop_flutter/model/state.dart';

AppState mainReducer(AppState state, dynamic action) {
// 退出
  if (action == MyActions.LogoutSuccess) {
    state.auth.isLogin = false;
    state.auth.userName = null;
    state.auth.password = null;
  }

// 登录
  if (action is LoginSuccessAction) {
    state.auth.isLogin = true;
    state.auth.userName = action.userName;
    state.auth.password = action.password;
  }

  return state;
}
