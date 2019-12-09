import 'package:flutter/material.dart';
import './../../model/state.dart';
import './../../model/actions.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';

class UserCenter extends StatefulWidget {
  @override
  _UserCenterState createState() => _UserCenterState();
}

class _UserCenterState extends State<UserCenter> {
  @override
  Widget build(BuildContext context) {
    return new StoreConnector(
      builder: (BuildContext context, AppState state) {
        return userDetail(state.auth.userName);
      },
      converter: (Store<AppState> store) {
        return store.state;
      },
    );
  }

  Widget userDetail(userName) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text('欢迎用户:$userName'),
        StoreConnector(
          builder: (BuildContext context, VoidCallback logout) {
            return RaisedButton(child: Text('退出'), onPressed: logout);
          },
          converter: (Store<AppState> store) {
            return () {
              return store.dispatch(MyActions.LogoutSuccess);
            };
          },
        )
      ],
    ));
  }
}
