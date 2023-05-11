import 'dart:convert';
import 'dart:io';

import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/model/widget/news_model.dart';
import 'package:flutter_app/screen/news_add_screen.dart';
import 'package:flutter_app/screen/web_view_screen.dart';
import 'package:flutter_app/service/http_service.dart';
import 'package:flutter_app/utilities/globalState.dart';
import 'package:flutter_app/utilities/globals.dart';
import 'package:flutter_app/widget/common/main_app_bar.dart';
import 'package:flutter_app/widget/common/main_button.dart';
import 'package:flutter_app/widget/list_item_widget.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  RefreshController _refreshController = RefreshController();
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();


  globalState _state = globalState();
  double imgOpacity = 1;
  int page = 0;
  int total = 0;
  bool loading = true;
  bool isAnimation = false;
  String? _selectedFilter = "";
  String? animationId = "";
  Map<String, String> filterList = {
    "": "Бүгд",
    "NEWS_CATEGORY_01": "Биржийн мэдээ",
    "NEWS_CATEGORY_02": "Мэдээлэл"
  };

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initValue();
  }

  initValue() async {
    await getNews(page, _selectedFilter ?? "");
  }

  getNews(int page, String filter) async {
    Map<String, String> query = {
      "page": page.toString(),
      "size": Globals().page_size.toString(),
      "filters": filter != "" ? ('["category_code","' + filter + '"]') : ""
    };
    debugPrint("query data " + query.toString());
    await Services().getRequest(Globals().api_news, query).then((response) {
      var data = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
      debugPrint("response" + response.body);
      debugPrint("response data" + data.toString());
      if (data.containsKey('items')) {
        total = data['total_pages'];
        debugPrint("total page " + total.toString());
        data['items'].forEach((item) {
          _state.list.add(
            new NewsModel(
              id: item["id"],
              title: item["title"],
              imgUrl: (item["image_path"].toString().substring(0, 1) == "/")
                  ? item["image_path"]
                  : "/" + item["image_path"],
              createdAt: DateTime.parse(item["created_at"]),
            ),
          );
        });
        debugPrint("medeenii urt " + _state.list.length.toString());
        _state.list.refresh();
      }
      loading = false;
    }).catchError((onError) {
      debugPrint(onError.toString());
      Get.snackbar("Алдаа", onError.toString());
      loading = false;
    });

    setState(() {});
  }

  List<Widget> drawNews() {
    List<Widget> ret = [];

    _state.list.forEach((news) {
      ret.add(
        ListItemWidget(
          id: news.id,
          title: news.title,
          imgUrl: news.imgUrl,
          createdAd: news.createdAt,
          isAnimation: this.isAnimation,
          animationId: this.animationId,
          onPress: () async {
            this.animationId = news.id;
            Get.to(() => WebViewScreen(
                  id: news.id,
                  title: 'Мэдээ',
                ))!.then((value){
                  setState(() {
                    if(this.isAnimation == false)
                      this.isAnimation = true;
                    else
                      this.isAnimation = false;
                  });
            });
          },
          onDelete: () async {
            if (await confirm(
              context,
              title: Text('Устгах'),
              content: Text('Та "' + news.title + '" гэсэн мэдээг утгах уу?'),
              textOK: Text('Тийм'),
              textCancel: Text('Үгүй'),
            )) {
              _state.list.removeWhere((element) => (element.id == news.id));
              _state.list.refresh();
              setState(() {});
            }
          },
        ),
      );
      ret.add(SizedBox(
        height: 10,
      ));
    });
    return ret;
  }

  void _onLoading() async {
    if (total > page) {
      page++;
      await getNews(page, _selectedFilter ?? "");
      _refreshController.loadComplete();
    } else {
      _refreshController.loadNoData();
    }
  }

  Future<void> _onRefresh() async {
    page = 0;
    _state.list.clear();
    await getNews(page, _selectedFilter ?? "");
    _refreshController.refreshCompleted();
  }

  _onFilter(value) async {
    setState(() {
      loading = true;
      _state.list.clear();
      page = 0;
      _selectedFilter = value;
    });
    _refreshController.resetNoData();
    await getNews(page, _selectedFilter ?? "");
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    debugPrint("Ognoo shuu" +
        DateTime.parse("2023-03-17T16:15:24.327262+08:00").toString());
    debugPrint("Ognoo" +
        DateFormat('yyyy-MM-dd')
            .format(DateTime.parse("2023-03-17T16:15:24.327262+08:00")));
    debugPrint("Tsag" +
        DateFormat('HH:mm:ss')
            .format(DateTime.parse("2023-03-17T16:15:24.327262+08:00")));
    debugPrint("Ognoo shuu" +
        DateTime.parse("2023-03-17T16:15:24.327262+08:00").toString());
    print(DateTime.parse("2023-03-17T16:15:24.327262+08:00"));
    // debugPrint(DateTime.parse("2023-03-17T16:15:24.327262+08:00"));
    return Scaffold(
      appBar: MainAppBar(title: "Мэдээний жагсаалт"),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Mainbutton(
                  text: "Нэмэх",
                  onPress: () {
                    Get.to(() => NewsAddScreen())!.then((value) {
                      print("OK shuu");
                      print(value);
                      if (value != null) {
                        _state.list.insert(0, value);
                        setState(() {});
                      }
                    });
                  },
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: DropdownButton(
                    items: filterList.entries
                        .map((e) => DropdownMenuItem(
                            child: Text(e.value), value: e.key))
                        .toList(),
                    value: _selectedFilter,
                    onChanged: (val) => _onFilter(val),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 20),
                  child: Center(
                      child: Text(
                          "Тайлбар: Та устгах бол мэдээн дээр удаан дарна уу.")),
                )
              ],
            ),
          ),
          (this.loading == true)
              ? Center(child: CircularProgressIndicator())
              : Expanded(
                  child: SmartRefresher(
                    enablePullDown: true,
                    enablePullUp: true,
                    onLoading: _onLoading,
                    onRefresh: _onRefresh,
                    controller: _refreshController,
                    child:
                        // Obx(() => ListView(
                        //       children: _state.list
                        //           .map((news) => ListItemWidget(
                        //                 id: news.id,
                        //                 title: news.title,
                        //                 imgUrl: news.imgUrl,
                        //                 createdAd: news.createdAt,
                        //                 onDelete: () async {
                        //                   debugPrint("delete");
                        //                   debugPrint(news.id);
                        //                   if (await confirm(
                        //                     context,
                        //                     title: Text('Устгах'),
                        //                     content: Text('Та "' +
                        //                         news.title +
                        //                         '" гэсэн мэдээг утгах уу?'),
                        //                     textOK: Text('Тийм'),
                        //                     textCancel: Text('Үгүй'),
                        //                   )){
                        //                     _state.list.forEach((element) {
                        //                       if(element.id == news.id){
                        //                        _state.list.remove(element);
                        //                        _state.list.refresh();
                        //                       }
                        //                     });
                        //                   };
                        //                 },
                        //                 onPress: () {
                        //                   Get.to(() => WebViewScreen(
                        //                         id: news.id,
                        //                         title: 'Мэдээ',
                        //                       ));
                        //                 },
                        //               ))
                        //           .toList(),
                        //     ))

                        ListView(
                      children:  drawNews(),
                    ),
                    // AnimatedList(key: _listKey,initialItemCount: _state.list.length, itemBuilder: (context, index, animation){
                    //   return ListItemWidget(id: _state.list[index].id, title: _state.list[index].title, createdAd: _state.list[index].createdAt, imgUrl: _state.list[index].imgUrl,);
                    // },)
                  ),
                ),
        ],
      ),
    );
  }
}
