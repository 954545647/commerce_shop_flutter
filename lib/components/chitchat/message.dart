// 消息列表
import 'package:flutter/material.dart';
import 'package:commerce_shop_flutter/components/common/top_title.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:provider/provider.dart';
import 'package:commerce_shop_flutter/provider/supplierData.dart';
import 'package:commerce_shop_flutter/utils/dio.dart';
import 'package:commerce_shop_flutter/provider/socketData.dart';

class Message extends StatefulWidget {
  @override
  _MessageState createState() => _MessageState();
}

class _MessageState extends State<Message> {
  IO.Socket mysocket;
  SupplierData supplierData;
  @override
  void initState() {
    super.initState();
    _initSocket();
  }

  Future<void> _initSocket() async {
    await Future.delayed(Duration(microseconds: 300), () async {
      mysocket = Provider.of<SocketData>(context).socket;
      _getMessage();
    });
  }

  Future<void> _getMessage() async {
    supplierData = Provider.of<SupplierData>(context);
    // print(supplierData.supplierInfo.id);
    DioUtils.getInstance().post("sMessage",
        data: {'id': supplierData.supplierInfo.id}).then((val) {
      // print(val);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color.fromRGBO(240, 240, 240, 1),
        child: Column(
          children: <Widget>[
            TopTitle(
              title: "消息列表",
              showArrow: true,
            ),
          ],
        ),
      ),
    );
  }
}
