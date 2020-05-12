import 'package:flutter/material.dart';
import 'package:commerce_shop_flutter/utils/dio.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import "package:commerce_shop_flutter/config/config.dart";

List history = [];

// 获取历史搜索
getHistorySearch(context) async {
  var data = await DioUtil.getInstance(context).get('searchHistory');
  if (data != null && data["data"] != null) {
    history = [];
    data["data"].forEach((item) => history.add(item["content"]));
  }
  return history;
}

// 新增历史查询
newHistorySearch(context, query) {
  DioUtil.getInstance(context)
      .post('newSearch', data: {"query": query}).then((val) {});
}

// 查询数据库
Future searchRes(context, query) async {
  var data =
      await DioUtil.getInstance(context).post('search', data: {"query": query});
  return data;
}

// 处理查询结果
handleSearch(context, query) async {
  if (query != null && query != "") {
    // 先保存当前搜索记录
    await newHistorySearch(context, query);
    // 查询数据库
    var data = await searchRes(context, query);
    return data;
  }
}

// 查询搜索结果
Future getSearchDetail(context, id, type) async {
  String path = "";
  if (type == 1) {
    path = "SgetSupplierById";
  }
  if (type == 2) {
    path = "getFarmsInfo";
  }
  if (type == 3) {
    path = "getGoodInfo";
  }
  var data = await DioUtil.getInstance(context).post(path, data: {"id": id});
  if (data != null && data["code"] == 200) {
    return data;
  }
}

class CustomSearchDelegate extends SearchDelegate {
  @override
  // 显示在输入框之后的部件
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        tooltip: "clear",
        icon: Icon(Icons.clear),
        onPressed: () {
          query = "";
          showSuggestions(context);
        },
      )
    ];
  }

  @override
  // 显示在输入框之前的部件，一般显示返回前一个页面箭头按钮
  // 显示一个箭头的按钮，使用 close 方法关闭搜索页面
  Widget buildLeading(BuildContext context) {
    return IconButton(
      tooltip: 'Back',
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  // 显示搜索结果
  Widget buildResults(BuildContext context) {
    return FutureBuilder(
      future: handleSearch(context, query),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          final post = snapshot.data;
          return ListView(
            children: searchData(post, context),
          );
        }
        if (snapshot.data == null) {
          return AlertDialog(
            content: new Text(
              "搜索内容不能为空",
            ),
          );
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  List<Widget> searchData(data, context) {
    List<Widget> list = [];
    var searchData = data["data"];
    var supplierData = searchData["supplier"];
    var farmData = searchData["farm"];
    var animalData = searchData["animal"];
    if (supplierData != null && supplierData.length > 0) {
      for (var i = 0; i < supplierData.length; i++) {
        list.add(supplier(context, supplierData[i]));
      }
    }
    if (farmData != null && farmData.length > 0) {
      for (int i = 0; i < farmData.length; i++) {
        list.add(farm(context, farmData[i]));
      }
    }
    if (animalData != null && animalData.length > 0) {
      for (var i = 0; i < animalData.length; i++) {
        if (animalData[i] != null && animalData[i]["status"] != null) {
          int status = animalData[i]["status"];
          if (status == 1) {
            list.add(animal(context, animalData[i]));
          }
        }
      }
    }
    if (list.length == 0) {
      list.add(Container(
        color: Colors.white,
        height: ScreenUtil().setHeight(1200),
        alignment: Alignment.center,
        child: Text(
          "暂无搜索数据",
          style: TextStyle(fontSize: 24),
        ),
      ));
    }
    return list;
  }

  Widget supplier(context, data) {
    String farmName = data["username"];
    String descript = data["phone"];
    return searchItem(context, data, farmName, descript, "商家");
  }

  Widget farm(context, data) {
    String farmName = data["farmName"];
    String descript = data["descript"];
    return searchItem(context, data, farmName, descript, "农场");
  }

  Widget animal(context, data) {
    String farmName = data["goodName"];
    String descript = data["descript"];
    return searchItem(context, data, farmName, descript, "动物");
  }

  // 单个搜索结果
  Widget searchItem(context, data, name, desc, tag) {
    return Container(
      height: ScreenUtil().setHeight(320),
      child: GestureDetector(
        onTap: () async {
          int id = data["id"];
          int type = data["type"];
          var res = await getSearchDetail(context, id, type);
          String jumpPath = "";
          if (type == 1) {
            res = res["data"];
            jumpPath = "supplier";
          }
          if (type == 2) {
            res = res["data"]["farmInfo"];
            jumpPath = "farmDetail";
          }
          if (type == 3) {
            res = res["data"];
            jumpPath = "homeGoodsDetail";
          }
          if (res != null) {
            Navigator.pushNamed(context, jumpPath, arguments: res);
          }
        },
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
          child: Row(
            children: <Widget>[
              Image.network(
                "${Config.apiHost}/${data['imgCover']}",
                width: ScreenUtil().setWidth(300),
                fit: BoxFit.contain,
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text(
                        tag,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    Text(name),
                    Text(desc),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  // 显示历史搜索
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder(
      future: getHistorySearch(context),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          final data = snapshot.data;
          return Wrap(
              spacing: 8.0, // gap between adjacent chips
              runSpacing: 4.0, // gap between lines
              children: historyText(data));
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  // 历史搜索记录
  List<Widget> historyText(data) {
    List<Widget> list = [];
    for (var i = 0; i < data.length; i++) {
      list.add(GestureDetector(
        child: Container(
          padding: EdgeInsets.fromLTRB(25, 10, 25, 10),
          margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
          decoration: BoxDecoration(
            border: Border.all(width: 1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(data[i]),
        ),
        onTap: () {
          query = data[i];
        },
      ));
    }
    return list;
  }
}
