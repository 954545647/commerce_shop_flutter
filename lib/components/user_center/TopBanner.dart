import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:commerce_shop_flutter/config/configuration.dart' as config;
import 'package:commerce_shop_flutter/components/user_center/UserInfo.dart';
// import 'package:commerce_shop_flutter/components/user_center/UserWealth.dart';

class TopBanner extends StatefulWidget {
  @override
  _TopBannerState createState() => _TopBannerState();
}

class _TopBannerState extends State<TopBanner> {
  ScrollController _controller = ScrollController();
  @override
  Widget build(BuildContext context) {
    return topBanner();
  }

  Widget topBanner() {
    return Container(
        // decoration: BoxDecoration(border: Border.all(color: Colors.red)),
        child: MediaQuery.removePadding(
      removeTop: true,
      context: context,
      child: SingleChildScrollView(
        controller: _controller,
        child: Column(
          children: <Widget>[
            Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Container(
                  width: ScreenUtil().setWidth(750),
                  height: ScreenUtil().setHeight(350),
                ),
                Positioned(
                  top: 0,
                  child: Container(
                    padding: EdgeInsets.fromLTRB(15, config.topHeight, 15, 15),
                    width: ScreenUtil().setWidth(750),
                    height: ScreenUtil().setHeight(300),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color.fromRGBO(45, 118, 202, 0.9),
                          Color.fromRGBO(72, 131, 202, 0.8),
                        ],
                      ),
                    ),
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            InkWell(
                              onTap: () {
                                Navigator.pushNamed(context, 'setting');
                              },
                              child: Container(
                                width: 20,
                                height: 20,
                                child: Icon(Icons.settings),
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 10.0),
                        // 用户基本信息模块
                        UserInfo()
                      ],
                    ),
                  ),
                ),
                // 积分数据模块
                // Positioned(
                //   bottom: 25,
                //   child: UserWealth(),
                // )
              ],
            )
          ],
        ),
      ),
    ));
  }
}
