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
                  Navigator.popAndPushNamed(context, "login");
                },
              ),
            ],
          ));
}

void payOrder(BuildContext context, String title, callback) {
  showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text(title),
            content: Container(
              child: Text("haha"),
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text("取消"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              new FlatButton(
                child: new Text("确定"),
                onPressed: () {},
              ),
            ],
          ));
}

void commonDialog(
    {BuildContext context,
    String title,
    String detail = "",
    String route,
    Function method,
    bool shouldExecute = true,
    bool needSkip = true}) {
  showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text(title),
            content: detail != ""
                ? Text(detail)
                : Container(
                    width: 0,
                    height: 0,
                  ),
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
                  if (shouldExecute) {
                    method();
                  }
                  Navigator.of(context).pop();
                  if (needSkip) {
                    Navigator.pushNamed(context, route);
                  }
                },
              ),
            ],
          ));
}
