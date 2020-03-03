import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:commerce_shop_flutter/components/common/common_title.dart';
import 'package:commerce_shop_flutter/components/common/top_title.dart';
import 'package:commerce_shop_flutter/components/common/good_banner.dart';
import 'package:commerce_shop_flutter/utils/dio.dart';

class NearFarm extends StatefulWidget {
  @override
  _NearFarmState createState() => _NearFarmState();
}

class _NearFarmState extends State<NearFarm> {
  List supplierLists = [];
  @override
  void initState() {
    super.initState();
    getSuppliers();
  }

  getSuppliers() {
    DioUtils.getInstance().get('getAllSuppliers').then((val) {
      if (val != null) {
        supplierLists = val["data"];
        setState(() {});
      }
    });
  }

  var imageList = [
    'https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=2822313456,3392103754&fm=26&gp=0.jpg',
    'https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=847580354,2285435867&fm=26&gp=0.jpg',
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: Container(
          child: ListView(
            children: <Widget>[
              // 标题
              CommonTitle(title: '附近农场'),
              // 商家轮播图
              GoodBanner(
                  imageList: imageList,
                  height: 360,
                  fraction: 0.8,
                  scale: 0.8,
                  topMargin: 10),
              TopTitle(title: '农场列表'),
              // 商家列表
              merchantLists(),
            ],
          ),
        ),
      ),
      // 顶部商品展示
    );
  }

  // 商家列表
  Widget merchantLists() {
    return Container(
      margin: EdgeInsets.all(15),
      child: Column(
        children: supplierLists.map((item) {
          return merchantDetail(item);
        }).toList(),
      ),
    );
  }

  // 商家详情
  Widget merchantDetail(data) {
    return GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, 'merchant', arguments: data);
        },
        child: Container(
          height: ScreenUtil().setHeight(240),
          margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black12),
              borderRadius: BorderRadius.circular(20)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Image.network(
                data['cover'],
                width: ScreenUtil().setWidth(240),
                height: ScreenUtil().setHeight(240),
                fit: BoxFit.cover,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      data['supplierName'],
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    SizedBox(height: 10),
                    Text(
                      data['address'],
                      style: TextStyle(color: Colors.grey),
                    )
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
