import 'package:flutter/material.dart';
import './pages/index.dart';

void main() {
  runApp(MyApp(
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return 
       MaterialApp(
        title: '认养农场',
        debugShowCheckedModeBanner: false, // 关闭debug显示条
        theme: ThemeData(
          // primaryColor: Colors.lightGreen,
        ),
        home: IndexPage()
    );
  }
}
