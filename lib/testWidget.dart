// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:guoding/api/data_utils.dart';
// import 'package:guoding/model/topic_head_bean.dart';
// import 'package:guoding/resources/my_dimens.dart';
// import 'package:guoding/resources/mycolor_resources.dart';
// import 'package:guoding/routers/application.dart';
// import 'package:guoding/ui/home/top/topic_list_page.dart';
// import 'package:guoding/widgets/my_tab_indicator.dart';

// class MoreTopicPage extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() {
//     return MoreTopicPageState();
//   }
// }

// class MoreTopicPageState extends State<MoreTopicPage>
//     with TickerProviderStateMixin {
//   bool hasTopLoad = false;

//   List<TopicHeadLists> mTabs = new List();

//   TabController _tabController;

//   int _selectedIndex;

//   @override
//   void initState() {
//     super.initState();
//     _tabController = new TabController(length: mTabs.length, vsync: this);
//     _tabController.addListener(() {
//       setState(() => _selectedIndex = _tabController.index);
//       print("liucheng-> ${_tabController.indexIsChanging}");
//     });
//     getTopicHorizatalData();
//   }

//   void getTopicHorizatalData() async {
//     DataUtils.getTopicHorizatalists().then((value) {
//       if (value != null) {
//         var jsData = json.decode(value);
//         int status = jsData['status'];
//         var data = jsData['data'];
//         TopicHeadBean headBean = TopicHeadBean.fromJson(jsonDecode(value));
//         print('${headBean.data.lists}');
//         mTabs.addAll(headBean.data.lists);
//         if (mounted) {}

//         setState(() {
//           hasTopLoad = true;
//           _tabController = new TabController(length: mTabs.length, vsync: this);
//         });
//       }
//     }).catchError((e) {
//       print('eee  getTopicHorizatalData  $e');
//     });
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     _tabController.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return new Scaffold(
//       body: SafeArea(
//         top: true,
//         child: Container(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: <Widget>[
//               Container(
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: <Widget>[
//                     GestureDetector(
//                       onTap: () {
//                         Application.router.pop(context);
//                       },
//                       child: Icon(
//                         Icons.arrow_back_ios,
//                         size: 20,
//                         color: MyColorRes.tvMainSelectColor,
//                       ),
//                     ),
//                     Text(
//                       '话题列表',
//                       style: TextStyle(
//                           fontSize: 20, color: MyColorRes.tvMainSelectColor),
//                     ),
//                     Icon(
//                       Icons.search,
//                       size: 30,
//                       color: MyColorRes.tvMainSelectColor,
//                     ),
//                   ],
//                 ),
//                 height: MyDimenRes.dp_title_height,
//                 margin: EdgeInsets.only(
//                   left: MyDimenRes.dp_base_left,
//                   right: MyDimenRes.dp_base_right,
//                 ),
//                 alignment: Alignment.bottomCenter,
//               ),
//               Divider(
//                 color: MyColorRes.divideLine,
//               ),
//               _buildRoot()
//             ],
//           ),
//           color: MyColorRes.bg_white,
//         ),
//       ),
//     );
//   }

//   Widget _buildRoot() {
//     if (!hasTopLoad) {
//       return Center(
//         child: Text('加载中...'),
//       );
//     } else {
//       return Container(
//         color: MyColorRes.bgTagColor,
//         height: MediaQuery.of(context).size.height - 100,
//         child: Column(
//           children: <Widget>[
//             Container(
//               height: 46,
//               child: TabBar(
//                 indicatorColor: MyColorRes.primaryColor,
//                 labelColor: MyColorRes.tvMainSelectColor,
//                 unselectedLabelColor: MyColorRes.tvMainUnSelectColor,
//                 unselectedLabelStyle: TextStyle(fontSize: 15),
//                 labelStyle: TextStyle(fontSize: 17),
//                 isScrollable: true,
//                 indicator: MyUnderlineTabIndicator(
//                     borderSide:
//                         BorderSide(width: 2.0, color: MyColorRes.primaryColor)),
//                 controller: _tabController,
//                 tabs: mTabs.map((value) {
//                   return Text(value.name);
//                 }).toList(),
//               ),
//               alignment: Alignment.centerLeft,
//               color: MyColorRes.bg_white,
//             ),
//             Expanded(
//               flex: 1,
//               child: TabBarView(
//                 children: _buildPages(),
//                 controller: _tabController,
//               ),
//             ),
//           ],
//         ),
//       );
//     }
//   }

//   List<Widget> _buildPages() {
//     List<Widget> pages = List();
//     for (int i = 0; i < mTabs.length; i++) {
//       Widget page = TopicListPage(mTabs[i].flId);
//       pages.add(page);
//     }
//     return pages;
//   }
// }
