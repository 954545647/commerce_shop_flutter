import 'package:flutter/material.dart';
import 'package:commerce_shop_flutter/pages/home.dart';
import 'package:commerce_shop_flutter/pages/market.dart';
import 'package:commerce_shop_flutter/pages/user_center.dart';
import 'package:commerce_shop_flutter/pages/rent_land.dart';
import 'package:commerce_shop_flutter/pages/welcome.dart';
import 'package:commerce_shop_flutter/pages/index.dart';
import 'package:commerce_shop_flutter/components/welcome/Login.dart';
import 'package:commerce_shop_flutter/model/reducer.dart';
import 'package:commerce_shop_flutter/model/state.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';

void main() {
  Store<AppState> store = new Store<AppState>(mainReducer,
      initialState: new AppState(auth: new AuthState()));
  runApp(MyApp(store: store));
}

class MyApp extends StatelessWidget {
  final Store<AppState> store;
  MyApp({Key key, this.store}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return new StoreProvider<AppState>(
        store: store,
        child: MaterialApp(
          title: '认养农场',
          debugShowCheckedModeBanner: false, // 关闭debug显示条
          theme: ThemeData(
            primaryColor: Color.fromRGBO(37, 102, 177, 1),
          ),
          routes: {
            '/welcome': (context) => Welcome(),
            '/index': (context)=> IndexPage(),
            '/home': (context) => Home(),
            '/login': (context) => Login(),
            '/market': (context, {arguments}) => Market(),
            '/userCenter': (context, {arguments}) => UserCenter(),
            '/rentLand': (context, {arguments}) => RentLand()
          },
          // initialRoute: '/welcome',
          home: new StoreConnector<AppState, AppState>(
            builder: (BuildContext context, AppState state) {
              return new Welcome(
                  isLogin: state.auth.isLogin, userName: state.auth.userName);
            },
            converter: (Store<AppState> store) {
              return store.state;
            },
          ),
        ));
  }
}

// class MyApp extends StatelessWidget {
//   final Store<AppState> store;
//   MyApp({Key key, this.store}) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     return
//         MaterialApp(
//           title: '认养农场',
//           debugShowCheckedModeBanner: false, // 关闭debug显示条
//           theme: ThemeData(
//             primaryColor: Color.fromRGBO(37, 102, 177, 1),
//           ),
//           routes: {
//             '/welcome': (context) => Welcome(),
//             '/home': (context) => Home(),
//             '/market': (context, {arguments}) => Market(),
//             '/userCenter': (context, {arguments}) => UserCenter(),
//             '/rentLand': (context, {arguments}) => RentLand()
//           },
//           // initialRoute: '/welcome',
//           home: Welcome(),
//         );
//   }
// }
