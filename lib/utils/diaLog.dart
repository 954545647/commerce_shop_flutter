import 'package:flutter/material.dart';

void loginDialog(BuildContext context, String title) {
  showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text(title),
            actions: <Widget>[
              new FlatButton(
                child: new Text("取消"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              new FlatButton(
                child: new Text("确定"),
                onPressed: () {
                  Navigator.pushNamed(context, "login");
                },
              ),
            ],
          ));
}
