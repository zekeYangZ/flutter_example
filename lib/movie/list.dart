import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_client_sse/constants/sse_request_type_enum.dart';
import 'package:flutter_client_sse/flutter_client_sse.dart';
import 'package:flutter_study/movie/detail.dart';
import 'package:flutter_study/utils/EncryptionUtils.dart';

Dio dio = Dio();

class MovieList extends StatefulWidget {
  // const MovieList({Key? key, required this.mt}) : super(key: key);
  const MovieList({super.key, required this.mt});

  final String mt;

  @override
  State<StatefulWidget> createState() {
    return _MovieListState();
  }
}

//有状态控件，必须结合一个状态管理类，来进行实现
//范型里面 写对应的控件
//非常重要 AutomaticKeepAliveClientMixin ，这个一定要加，这个可以防止页面页面重复请求，加上这个可以让数据的状态得到保存。
//比如这个viewpager 滑走之后再回来，状态可以保存，要记得加上：
//  bool get wantKeepAlive => true;
class _MovieListState extends State<MovieList>
    with AutomaticKeepAliveClientMixin {
  //默认显示第一条数据
  int page = 1;

  //每页显示的条数
  int pageSize = 10;

  //电影列表数据
  var mList = [];

  //总数据条数，实现分页效果
  var total = 0;

  @override
  void initState() {
    super.initState();
    //控件被创建的时候会执行这个initState。
    getMovieList();

    // var params = {
    //   "historyList": [
    //     {"role": 'user', "content": "hello"}
    //   ]
    // };
    //
    // var ss = jsonEncode(params);
    // print(ss);
    // var encodeParams = ParamsTools.encodeAesRsaParams(ss);
    // print("yyzzencode=${jsonEncode(encodeParams)}");
    // SSEClient.subscribeToSSE(
    //     body: encodeParams,
    //     method: SSERequestType.POST,
    //     url: 'https://zekeyconsulting.uk/stream/gptData',
    //     header: {
    //       //post 要加 application/json 否则服务端获取的是空
    //       'Content-Type': 'application/json',
    //       "Accept": "text/event-stream",
    //       "Cache-Control": "no-cache",
    //     }).listen(
    //   (event) {
    //     // print('Id: ' + event.id!);
    //     // print('Event: ' + event.event!);
    //     var data = event.data;
    //     if (data != null) {
    //       var result = ParamsTools.decodeAesRsaParams(jsonDecode(data));
    //       print('Data: $result');
    //     }
    //   },
    // );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ListView.builder(
        itemCount: mList.length,
        itemBuilder: (BuildContext buildContent, int i) {
          //拿到每个item的值
          var mItem = mList[i];
          return Container(
              height: 200,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(top: BorderSide(color: Colors.black12))),
              // GestureDetector 相当于给整个布局加上一个点击事件
              child: GestureDetector(
                  onTap: () {
                    //这里是路由跳转
                    Navigator.push(context,
                        MaterialPageRoute(builder: (BuildContext ctx) {
                      return MovieDetail(
                        id: mItem['id'].toString(),
                        title: mItem['title'],
                      );
                    }));
                  },
                  child: Row(children: [
                    Image.network(
                      'https://img2.baidu.com/it/u=612844894,2239973497&fm=253&fmt=auto&app=138&f=JPEG?w=334&h=500',
                      width: 130,
                      height: 180,
                      fit: BoxFit.cover,
                    ),
                    Container(
                        height: 200,
                        padding: EdgeInsets.only(left: 10),
                        //CrossAxisAlignment.start 左对齐
                        //MainAxisAlignment.spaceAround 分散对齐
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text("电影名称:${mItem['title']}"),
                              Text("上映年份:${mItem['author']}"),
                              Text("电影类型:${mItem['chapterName']}"),
                              Text("豆瓣评分:${mItem['niceShareDate']}"),
                              Text("主要演员:${mItem['superChapterName']}"),
                            ]))
                  ])));
        });
  }

  //定义获取数据的方法
  getMovieList() async {
    //js 中有模版字符串
    //dart 也有
    //偏移量计算公式 (page - 1) * pageSize
    int offset = (page - 1) * pageSize;
    // var url = "http://www.liulongbin.top:3005/api/v2/movie/${widget.mt}?start=$offset&count=$pageSize";
    var url =
        "https://www.wanandroid.com/article/list/$page/json?page_size=$pageSize";

    print("yyzzurl=${url}");
    // var url = "https://www.baidu.com/";
    var response = await dio.get(url);
    var result = response.data;
    var data = result['data'];
    //今后只要为私有数据赋值，都需要吧赋值的操作，放到setState 函数中，否则页面不会刷新。
    setState(() {
      mList = data['datas'];
    });
  }

  @override
  bool get wantKeepAlive => true;
}
