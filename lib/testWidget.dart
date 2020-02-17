// // 优惠卷主页
// import 'package:flutter/material.dart';
// import 'package:commerce_shop_flutter/utils/dio.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:commerce_shop_flutter/components/common/top_title.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// class Coupon extends StatefulWidget {
//   @override
//   _CouponState createState() => _CouponState();
// }

// class _CouponState extends State<Coupon> with SingleTickerProviderStateMixin {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: <Widget>[
//           Column(
//             children: <Widget>[
//               Container(height: getTopBarHeight(), color: Colors.white),
//               getTop('填写售后信息'),
//               getLine(size: ScreenUtil.getInstance().getWidth(20), width: 0),
//               Container(
//                 height: ScreenUtil.getInstance().screenHeight -
//                     ScreenUtil.getInstance().getWidth(100) -
//                     getTopBarHeight() -
//                     MediaQuery.of(context)
//                         .viewInsets
//                         .bottom, //输入法 高度 此高度跟随输入法变化
//                 child: Scrollbar(
//                   //包裹让其可以滑动
//                   child: SingleChildScrollView(
//                     scrollDirection: Axis.vertical,
//                     reverse: true,
//                     padding: EdgeInsets.all(0.0),
//                     physics: BouncingScrollPhysics(),
//                     child: Column(
//                       children: <Widget>[
//                         Container(
//                           alignment: Alignment.centerLeft,
//                           margin: EdgeInsets.fromLTRB(
//                               ScreenUtil.getInstance().getWidth(20),
//                               0,
//                               ScreenUtil.getInstance().getWidth(20),
//                               0),
//                           height: ScreenUtil.getInstance().getWidth(90),
//                           width: double.infinity,
//                           child: Text(
//                             '售后原因：订单金额有误',
//                             style: TextStyle(
//                                 color: MyColors.color_79,
//                                 fontSize:
//                                     ScreenUtil.getInstance().getWidth(30)),
//                           ),
//                         ),
//                         getLine(
//                             size: ScreenUtil.getInstance().getWidth(1),
//                             width: 0,
//                             color: '#E5E5E5'),
//                         Container(
//                           alignment: Alignment.centerLeft,
//                           margin: EdgeInsets.fromLTRB(
//                               ScreenUtil.getInstance().getWidth(20),
//                               0,
//                               ScreenUtil.getInstance().getWidth(20),
//                               0),
//                           height: ScreenUtil.getInstance().getWidth(80),
//                           width: double.infinity,
//                           child: Row(
//                             children: <Widget>[
//                               Text(
//                                 '请选择您需要申请售后的商品',
//                                 style: TextStyle(
//                                     color: MyColors.color_home_top_text,
//                                     fontSize:
//                                         ScreenUtil.getInstance().getWidth(30)),
//                               ),
//                               getStart()
//                             ],
//                           ),
//                         ),
//                         Container(
//                           margin: EdgeInsets.only(
//                               left: ScreenUtil.getInstance().getWidth(10),
//                               right: ScreenUtil.getInstance().getWidth(10)),
//                           padding: EdgeInsets.fromLTRB(
//                               ScreenUtil.getInstance().getWidth(10),
//                               ScreenUtil.getInstance().getWidth(20),
//                               ScreenUtil.getInstance().getWidth(10),
//                               ScreenUtil.getInstance().getWidth(20)),
//                           color: MyColors.color_F9,
//                           child: Stack(
//                             alignment: Alignment.bottomRight,
//                             children: <Widget>[
//                               Row(
//                                 children: <Widget>[
//                                   Image.asset(
//                                     Utils.getImgPath('bg_goods_default'),
//                                     height:
//                                         ScreenUtil.getInstance().getWidth(138),
//                                     width:
//                                         ScreenUtil.getInstance().getWidth(138),
//                                   ),
//                                   Container(
//                                     width:
//                                         ScreenUtil.getInstance().getWidth(430),
//                                     height:
//                                         ScreenUtil.getInstance().getWidth(138),
//                                     margin: EdgeInsets.only(
//                                         left: ScreenUtil.getInstance()
//                                             .getWidth(10),
//                                         right: ScreenUtil.getInstance()
//                                             .getWidth(10)),
//                                     child: Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: <Widget>[
//                                         Container(
//                                           height: ScreenUtil.getInstance()
//                                               .getWidth(100),
//                                           child: Text(
//                                             '大师傅的世风不古发挥更加开阔更加开阔',
//                                             style: TextStyle(
//                                                 fontSize:
//                                                     ScreenUtil.getInstance()
//                                                         .getSp(28),
//                                                 color: MyColors
//                                                     .color_home_top_text),
//                                             maxLines: 2,
//                                           ),
//                                         ),
//                                         Text('实际付款￥10.99',
//                                             style: TextStyle(
//                                                 fontSize:
//                                                     ScreenUtil.getInstance()
//                                                         .getSp(28),
//                                                 color: MyColors
//                                                     .color_home_top_text))
//                                       ],
//                                     ),
//                                   ),
//                                   Container(
//                                     alignment: Alignment.topRight,
//                                     height:
//                                         ScreenUtil.getInstance().getWidth(134),
//                                     child: Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.end,
//                                       children: <Widget>[
//                                         Text(
//                                           S.of(context).null_rmb + '33.90',
//                                           style: TextStyle(
//                                               color:
//                                                   MyColors.color_home_top_text,
//                                               fontSize: ScreenUtil.getInstance()
//                                                   .getSp(26)),
//                                         ),
//                                         Padding(
//                                           padding: EdgeInsets.only(
//                                               top: ScreenUtil.getInstance()
//                                                   .getWidth(10)),
//                                           child: Text(
//                                             'x2',
//                                             style: TextStyle(
//                                                 color: MyColors.color_79,
//                                                 fontSize:
//                                                     ScreenUtil.getInstance()
//                                                         .getSp(26)),
//                                           ),
//                                         )
//                                       ],
//                                     ),
//                                   )
//                                 ],
//                               ),
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.end,
//                                 children: <Widget>[
//                                   GestureDetector(
//                                     onTap: () {
//                                       LogUtil.e("jianshao商品");
//                                     },
//                                     child: Image.asset(Utils.getImgPath(
//                                         'refund_commit_cut_goods')),
//                                   ),
//                                   Container(
//                                     margin: EdgeInsets.only(
//                                         left: ScreenUtil.getInstance()
//                                             .getWidth(14),
//                                         right: ScreenUtil.getInstance()
//                                             .getWidth(14)),
//                                     child: Text(
//                                       '2',
//                                       style: TextStyle(
//                                           fontSize: ScreenUtil.getInstance()
//                                               .getSp(30),
//                                           color: MyColors.color_home_top_text),
//                                     ),
//                                   ),
//                                   GestureDetector(
//                                     onTap: () {
//                                       LogUtil.e("添加商品");
//                                     },
//                                     child: Image.asset(Utils.getImgPath(
//                                         'refund_commit_add_goods')),
//                                   ),
//                                 ],
//                               )
//                             ],
//                           ),
//                         ),
//                         Container(
//                           height: ScreenUtil.getInstance().getWidth(92),
//                           alignment: Alignment.centerLeft,
//                           margin: EdgeInsets.fromLTRB(
//                               ScreenUtil.getInstance().getWidth(20),
//                               0,
//                               ScreenUtil.getInstance().getWidth(20),
//                               0),
//                           child: Row(
//                             children: <Widget>[
//                               Container(
//                                 width: ScreenUtil.getInstance().getWidth(340),
//                                 child: Text(
//                                   '预计退款',
//                                   style: TextStyle(
//                                       fontSize:
//                                           ScreenUtil.getInstance().getWidth(30),
//                                       color: MyColors.color_home_top_text),
//                                 ),
//                               ),
//                               Container(
//                                 width: ScreenUtil.getInstance().getWidth(340),
//                                 alignment: Alignment.centerRight,
//                                 child: Text(
//                                   S.of(context).null_rmb + " " + "0.00",
//                                   style: TextStyle(
//                                       fontSize:
//                                           ScreenUtil.getInstance().getWidth(30),
//                                       color: MyColors.color_main),
//                                 ),
//                               )
//                             ],
//                           ),
//                         ),
//                         getLine(
//                             size: ScreenUtil.getInstance().getWidth(1),
//                             width: 0,
//                             color: '#E5E5E5'),
//                         Container(
//                           margin: EdgeInsets.fromLTRB(
//                               ScreenUtil.getInstance().getWidth(20),
//                               ScreenUtil.getInstance().getWidth(30),
//                               ScreenUtil.getInstance().getWidth(20),
//                               ScreenUtil.getInstance().getWidth(18)),
//                           child: Row(
//                             children: <Widget>[
//                               Text(
//                                 '说明',
//                                 style: TextStyle(
//                                     fontSize:
//                                         ScreenUtil.getInstance().getSp(30),
//                                     color: MyColors.color_home_top_text),
//                               ),
//                               getStart()
//                             ],
//                           ),
//                         ),
//                         Container(
//                           width: double.infinity,
//                           height: ScreenUtil.getInstance().getWidth(160),
//                           margin: EdgeInsets.fromLTRB(
//                               ScreenUtil.getInstance().getWidth(20),
//                               0,
//                               ScreenUtil.getInstance().getWidth(20),
//                               0),
//                           decoration: BoxDecoration(
//                             border: new Border.all(
//                                 color: MyColors.color_input_text_hint,
//                                 width: ScreenUtil.getInstance().getWidth(1)),
//                             // 边色与边宽
//                             shape: BoxShape.rectangle,
//                             // 默认值也是矩形
//                           ),
//                           child: Padding(
//                             padding: EdgeInsets.fromLTRB(
//                                 ScreenUtil.getInstance().getWidth(24),
//                                 ScreenUtil.getInstance().getWidth(16),
//                                 ScreenUtil.getInstance().getWidth(24),
//                                 ScreenUtil.getInstance().getWidth(16)),
//                             child: TextField(
//                               controller: _feedBackControllder,
//                               minLines: 3,
//                               maxLines: 5,
//                               decoration: InputDecoration(
//                                 contentPadding:
//                                     const EdgeInsets.symmetric(vertical: 4.0),
//                                 hintText: '请描述售后原因',
//                                 hintStyle: TextStyle(
//                                     fontSize:
//                                         ScreenUtil.getInstance().getWidth(28),
//                                     color: MyColors.color_input_text_hint),
//                                 border: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(15),
//                                     borderSide: BorderSide.none),
//                               ),
//                             ),
//                           ),
//                         ),
//                         Container(
//                           margin: EdgeInsets.fromLTRB(
//                               ScreenUtil.getInstance().getWidth(20),
//                               ScreenUtil.getInstance().getWidth(30),
//                               ScreenUtil.getInstance().getWidth(20),
//                               ScreenUtil.getInstance().getWidth(18)),
//                           child: Row(
//                             children: <Widget>[
//                               Text(
//                                 '上传照片',
//                                 style: TextStyle(
//                                     fontSize:
//                                         ScreenUtil.getInstance().getSp(30),
//                                     color: MyColors.color_home_top_text),
//                               ),
//                               getStart(),
//                               Text(
//                                 "（请上传商品照片，照片需包含标签）",
//                                 style: TextStyle(
//                                     fontSize:
//                                         ScreenUtil.getInstance().getWidth(26),
//                                     color: MyColors.color_input_text_hint),
//                               )
//                             ],
//                           ),
//                         ),
//                         Container(
//                           margin: EdgeInsets.only(
//                               left: ScreenUtil.getInstance().getWidth(20),
//                               right: ScreenUtil.getInstance().getWidth(20),
//                               bottom: ScreenUtil.getInstance().getWidth(70)),
//                           child: Row(
//                             children: <Widget>[
//                               Container(
//                                 decoration: BoxDecoration(
//                                     border: new Border.all(
//                                         color: MyColors.color_input_text_hint,
//                                         width: ScreenUtil.getInstance()
//                                             .getWidth(1)),
//                                     // 边色与边宽
//                                     shape: BoxShape.rectangle,
//                                     // 默认值也是矩形
//                                     color: MyColors.color_white),
//                                 alignment: Alignment.center,
//                                 height: ScreenUtil.getInstance().getWidth(126),
//                                 width: ScreenUtil.getInstance().getWidth(126),
//                                 child: Image.asset(
//                                     Utils.getImgPath('refund_commit_5_img')),
//                               )
//                             ],
//                           ),
//                         ),
//                         Container(
//                           margin: EdgeInsets.only(
//                               left: ScreenUtil.getInstance().getWidth(20),
//                               right: ScreenUtil.getInstance().getWidth(20)),
//                           child: MaterialButton(
//                             onPressed: isCommit != 0
//                                 ? () {
//                                     _onClickNext();
//                                   }
//                                 : null,
//                             height: ScreenUtil.getInstance().getWidth(80),
//                             minWidth: ScreenUtil.getInstance().getWidth(648),
//                             child: Text(
//                               '提交',
//                               style: TextStyle(
//                                   color: isCommit != 0
//                                       ? Colors.white
//                                       : MyColors.color_red_pack_data,
//                                   fontSize:
//                                       ScreenUtil.getInstance().getWidth(36)),
//                               textAlign: TextAlign.center,
//                             ),
//                             color: MyColors.color_main,
//                             disabledColor: MyColors.color_input_button_no_click,
//                             shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(
//                                     ScreenUtil.getInstance().getWidth(8)),
//                                 side: BorderSide(
//                                     width: ScreenUtil.getInstance().getWidth(1),
//                                     color: MyColors.color_CE)),
//                             elevation: 0,
//                             //按钮下面的阴影
//                             highlightElevation: 0,
//                             //高亮时候的阴影
//                             disabledElevation: 0, //按下的时候的阴影
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               )
//             ],
//           ),
//         ],
//       ),
//       backgroundColor: MyColors.color_white,
//       resizeToAvoidBottomPadding: false,
//     );
//   }
// }
