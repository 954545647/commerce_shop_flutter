import 'package:flutter/material.dart';
import 'package:commerce_shop_flutter/utils/dio.dart';
import 'package:provider/provider.dart';
import 'package:commerce_shop_flutter/provider/userData.dart';
import 'package:commerce_shop_flutter/pages/index.dart';
import "package:commerce_shop_flutter/config/config.dart";

class UnpayDialog extends StatelessWidget {
  final String title;
  final dynamic data;
  final int curItem;

  UnpayDialog({
    this.title,
    this.data,
    this.curItem,
  });

// 支付订单，修改订单状态
  payOrder(orderId) {
    DioUtils.getInstance()
        .post("modifyOrderStatus", data: {"orderId": orderId});
  }

// 修改用户的积分
  modifyUserPoint() {
    DioUtils.getInstance().post("changeIntegral", data: {"source": 2});
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Consts.padding),
        ),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        child: dialogContent(context),
      ),
    );
  }

  dialogContent(BuildContext context) {
    return Stack(
      children: <Widget>[
        buildCard(context),
      ],
    );
  }

  Widget buildCard(BuildContext context) {
    final user = Provider.of<UserData>(context);
    String address = user.userInfo.address;
    return Positioned(
      top: 60,
      left: Consts.padding,
      right: Consts.padding,
      child: Container(
        padding: EdgeInsets.only(
          top: Consts.avatarRadius + Consts.padding,
          bottom: Consts.avatarRadius + Consts.padding,
          left: Consts.avatarRadius + Consts.padding,
          right: Consts.avatarRadius + Consts.padding,
        ),
        margin: EdgeInsets.only(top: Consts.avatarRadius),
        decoration: new BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(Consts.padding),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10.0,
              offset: const Offset(0.0, 10.0),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min, // To make the card compact
          children: <Widget>[
            Text(
              title,
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 16.0),
            goodList(address),
            SizedBox(height: 10.0),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      payOrder(data["id"]);
                      // 删除Provider中对应未支付
                      // user.deleteUnpayOrder(userId, curItem);
                      // 更改用户积分
                      modifyUserPoint();
                      Navigator.of(context).push(new MaterialPageRoute(
                        builder: (context) {
                          return new IndexPage();
                        },
                      ));
                    },
                    child: Container(
                      child: Text('支付'),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      child: Text('取消'),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  goodList(address) {
    List<Widget> list = [];
    var details = data["Order_Details"];
    for (var i = 0; i < details.length; i++) {
      list.add(goodItem(details[i], address, i, details.length));
    }
    return Column(
      children: list,
    );
  }

  Widget goodItem(data, address, index, len) {
    return Container(
      // height: 120,
      width: 200,
      margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Image.network(
                "${Config.apiHost}${data["good_cover"]}",
                width: 120,
                height: 80,
                fit: BoxFit.fill,
              ),
              SizedBox(width: 20),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(data["good_name"]),
                  Text(data["good_count"].toString()),
                  Text(data["good_price"].toString()),
                ],
              )
            ],
          ),
          index + 1 == len
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[Text("用户地址："), Text(address)],
                )
              : Container(height: 0.0, width: 0.0)
        ],
      ),
    );
  }
}

class Consts {
  Consts._();
  static const double padding = 12.0;
  static const double avatarRadius = 12.0;
}
