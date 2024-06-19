//导入相关组件
import 'package:flutter/material.dart';
import 'package:flutter_study/movie/list.dart';
import 'package:flutter_study/utils/EncryptionUtils.dart';

void main() {
  //入口函数
  runApp(const MyApp());
}

//无状态控件 StatelessWidget
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //每个项目最外层，必须有 MaterialApp
    return MaterialApp(
      title: 'Flutter Demo111',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.pink),
        useMaterial3: true,
      ),
      home: const MyHome(),
    );
  }
}

class MyHome extends StatelessWidget {
  const MyHome({super.key});

  @override
  Widget build(BuildContext context) {
    //在 flutter 中 每个控件都是一个类
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: Text("电影列表"),
            centerTitle: true,
            //右侧行为按钮
            actions: [
              IconButton(
                  onPressed: () {
                    //这里就是 点击右侧按钮的行为
                  },
                  icon: Icon(Icons.search))
            ],
          ),
          drawer: Drawer(
            child: ListView(
              //将顶部设置没有边距更加好看
              padding: EdgeInsets.all(0),
              children: const [
                UserAccountsDrawerHeader(
                  //
                  accountName: Text("张三"),
                  //
                  accountEmail: Text("abc@gmial.com"),
                  //头像
                  currentAccountPicture: CircleAvatar(
                    backgroundImage: NetworkImage(
                        'https://img1.baidu.com/it/u=1023452347,2490968251&fm=253&fmt=auto&app=120&f=JPEG?w=500&h=500'),
                  ),
                  //美化当前控件的
                  decoration: BoxDecoration(
                      //背景图片
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(
                              'https://img1.baidu.com/it/u=83096473,758429730&fm=253&fmt=auto&app=138&f=JPEG?w=640&h=300'))),
                ),
                ListTile(title: Text("用户反馈"), trailing: Icon(Icons.feedback)),
                ListTile(title: Text("系统设置"), trailing: Icon(Icons.settings)),
                ListTile(title: Text("我要发布"), trailing: Icon(Icons.send)),
                //分割线
                Divider(
                  color: Colors.grey,
                ),
                ListTile(title: Text("注销"), trailing: Icon(Icons.exit_to_app))
              ],
            ),
          ),
          //底部的 tabbar
          bottomNavigationBar: Container(
            //美化当前的 container 盒子
            decoration: const BoxDecoration(color: Colors.white),
            //一般高度都是50
            height: 50,
            child: const TabBar(
                labelStyle: TextStyle(height: 0, fontSize: 10),
                tabs: [
                  Tab(icon: Icon(Icons.movie_filter), text: "正在热映"),
                  Tab(icon: Icon(Icons.movie_creation), text: "即将上映"),
                  Tab(icon: Icon(Icons.local_movies), text: "top250"),
                ]),
          ),
          body: const TabBarView(
            children: [
              MovieList(mt: 'in_theaters',),
              MovieList(mt: 'coming_soon',),
              MovieList(mt: 'top_250',),
            ],
          ),
        ));
  }
}
