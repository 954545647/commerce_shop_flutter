import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:commerce_shop_flutter/utils/dio.dart';

class GoodsCard extends StatefulWidget {
  final data;
  GoodsCard({Key key, this.data}) : super(key: key);
  @override
  _GoodsCardState createState() => _GoodsCardState();
}

class _GoodsCardState extends State<GoodsCard> {
  // 保存当前点击商品的id
  saveGoodId(goodId) {
    DioUtils.getInstance().post('saveId', data: {"goodId": goodId});
  }

  @override
  Widget build(BuildContext context) {
    var id = widget.data['id'];
    var name = widget.data['goodName'];
    var price = widget.data['price'];
    var desc = widget.data['descript'];
    var stock = widget.data['stock'];
    var imgCover = widget.data['imgCover'];
    var sales = widget.data['sales'];
    var expressCost = widget.data['expressCost'];
    var from = widget.data['from'];
    var supplierId = widget.data['supplierId'];
    return Container(
      margin: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            blurRadius: 6,
            spreadRadius: 4,
            color: Color.fromARGB(20, 0, 0, 0),
          ),
        ],
      ),
      child: GestureDetector(
        onTap: () {
          saveGoodId(widget.data["id"]);
          Navigator.pushNamed(context, 'homeGoodsDetail',
              arguments:
                  '{"id":$id,"name":"$name","price":$price,"desc":"$desc","stock":"$stock","imgCover":"$imgCover","sales":"$sales","expressCost":"$expressCost","supplierId":$supplierId,"from":"$from"}');
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            this.renderCover(),
            this.renderGoodsInfo(),
            this.renderGoodsDetail(),
          ],
        ),
      ),
    );
  }

  // 封面图
  Widget renderCover() {
    return Stack(
      fit: StackFit.passthrough,
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(8),
            topRight: Radius.circular(8),
          ),
          child: Image.network(
            widget.data["imgCover"],
            height: 200,
            fit: BoxFit.fitWidth,
          ),
        ),
        Positioned(
          left: 0,
          top: 100,
          right: 0,
          bottom: 0,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromARGB(0, 0, 0, 0),
                  Color.fromARGB(80, 0, 0, 0),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // 商品简介
  Widget renderGoodsInfo() {
    return Container(
      height: ScreenUtil().setHeight(120),
      padding: EdgeInsets.fromLTRB(10.0, 0, 0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            widget.data["goodName"],
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: 20.0),
          ),
          Text(
            '介绍: ${widget.data["descript"]}',
            textAlign: TextAlign.left,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: Colors.grey),
          )
        ],
      ),
    );
  }

  // 商品详情参数
  Widget renderGoodsDetail() {
    return Container(
      height: ScreenUtil().setHeight(80),
      decoration: BoxDecoration(
          border: Border(
        top:
            BorderSide(color: Colors.black, width: 1, style: BorderStyle.solid),
      )),
      child: Row(
        children: <Widget>[
          Expanded(
              child: renderGoodsDetailItem(
                  '认养价格', widget.data["price"].toString())),
          Expanded(
              child:
                  renderGoodsDetailItem('销量', widget.data["sales"].toString())),
          Expanded(
              child:
                  renderGoodsDetailItem('库存', widget.data["stock"].toString()))
        ],
      ),
    );
  }

  // 商品详情
  Widget renderGoodsDetailItem(String type, data) {
    if (type == '库存') {
      return Container(
        child: Column(
          children: <Widget>[Text(type), Text(data)],
        ),
      );
    } else {
      return Container(
        decoration: BoxDecoration(
            border: Border(
          right: BorderSide(
              color: Colors.black, width: 1, style: BorderStyle.solid),
        )),
        child: Column(
          children: <Widget>[Text(type), Text(data)],
        ),
      );
    }
  }
}
