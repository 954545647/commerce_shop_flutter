import 'package:flutter/material.dart';
import 'package:commerce_shop_flutter/components/common/top_title.dart';
import 'package:commerce_shop_flutter/components/home/hot_goods.dart';

class Sucess extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: Scaffold(
        body: Container(
          child: ListView(
            children: <Widget>[
              // 标题
              TopTitle(title: '支付成功'),
              SizedBox(height: 10),
              Container(
                color: Colors.white,
                height: 180,
                child: Column(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.center,
                      height: 100,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            IconData(0xe654, fontFamily: "myIcons"),
                            color: Colors.green,
                            size: 30,
                          ),
                          SizedBox(width: 5),
                          Text(
                            "付款成功",
                            style: TextStyle(fontSize: 20),
                          )
                        ],
                      ),
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          GestureDetector(
                            child: Container(
                              padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                      color: Colors.black26, width: 1),
                                  borderRadius: BorderRadius.circular(2)),
                              child: Text("返回首页"),
                            ),
                            onTap: () {
                              Navigator.pushNamed(context, "index");
                            },
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          GestureDetector(
                            child: Container(
                              padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                      color: Colors.black26, width: 1),
                                  borderRadius: BorderRadius.circular(2)),
                              child: Text("查看订单"),
                            ),
                            onTap: () {
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  'allOrder', ModalRoute.withName('index'));
                            },
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 10),
              HotGoods(),
            ],
          ),
        ),
      ),
    );
  }
}
