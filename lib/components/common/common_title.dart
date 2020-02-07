import 'package:flutter/material.dart';
import './top_title.dart';

class CommonTitle extends StatelessWidget {
  final String title;
  CommonTitle({this.title});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.white)
        )
      ),
      child: Column(
        children: <Widget>[
          Stack(
            alignment: const Alignment(-0.9, 0.5),
            children: <Widget>[
              TopTitle(title: title.toString()),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(Icons.chevron_left, size: 35),
              )
            ],
          )
        ],
      ),
    );
  }
}
