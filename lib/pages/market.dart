import 'package:flutter/material.dart';

class Market extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('集市'),
      ),
      body: Center(
        child: InkWell(
          onTap: (){
            Navigator.pushNamed(context, '/userCenter');
          },
          child: Text('集市'),
        )
      ),
    );
  }
}
