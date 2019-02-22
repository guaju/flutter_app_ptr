import 'package:flutter/material.dart';

//营造效果，导入异步包
import 'dart:async';

void main() => runApp(MyApp());

//刷新状态枚举
enum LoadingStatus {
  //正在加载中
  STATUS_LOADING,
  //数据加载完毕
  STATUS_COMPLETED,
  //空闲状态
  STATUS_IDEL
}

class MyApp extends StatelessWidget {
  ProgressIndicator pro;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'ptr'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //限制一滑动到最下方就刷新，在刷新数据 及 刷新完之后改变状态
  static var loadStatus = LoadingStatus.STATUS_IDEL;
  static int pageCount = 15;

  //自定义进度条颜色
  static var lAnimColor = AlwaysStoppedAnimation(Colors.red);
  static var cAnimColor = AlwaysStoppedAnimation(Colors.blue);

  //线性进度条
  static var myLPI = new LinearProgressIndicator(
    backgroundColor: Colors.grey,
    valueColor: lAnimColor,
    value: 0.5,
  );

  //环形进度条
  static var myCPI = new CircularProgressIndicator(
    backgroundColor: Colors.grey,
    valueColor: cAnimColor,
    value: 0.8,
  );

  //ProgressIndicator 演示
  var body1 = new Column(children: <Widget>[
    Padding(child: myLPI, padding: EdgeInsets.fromLTRB(0, 20, 0, 40)),
    myCPI
  ]);

  //定义整个页面的数据源 list
  static List list = new List();

  //定义加载中默认文字
  String loadText = "加载中...";

  //定义 ListView 的监听， ScrollController ScrollController 能够添加对ListView的滑动监听
  ScrollController _scrollController = new ScrollController();

// 定义两个加padding方法
  Widget _pada(Widget widget, var value) {
    return new Padding(padding: EdgeInsets.all(value), child: widget);
  }

  Widget _pad(Widget widget, {l, t, r, b}) {
    return new Padding(
        padding:
            EdgeInsets.fromLTRB(l ??= 0.0, t ??= 0.0, r ??= 0.0, b ??= 0.0),
        child: widget);
  }

//  加载中的布局
  Widget _loadingView() {
    var loadingTS = TextStyle(color: Colors.blue, fontSize: 16);
//    var loadingText=new Opacity(opacity: loadStatus==LoadingStatus.STATUS_LOADING?1.0:0,child:_pad(Text(loadText,style: loadingTS),l:20.0));
    var loadingText = _pad(Text(loadText, style: loadingTS), l: 20.0);
//    var loadingIndicator=new Opacity(opacity: loadStatus==LoadingStatus.STATUS_LOADING?1.0:0,child:SizedBox(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.blue)),width: 20.0,height: 20.0,));
    var loadingIndicator = new Visibility(
        visible: loadStatus == LoadingStatus.STATUS_LOADING ? true : false,
        child: SizedBox(
          child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Colors.blue)),
          width: 20.0,
          height: 20.0,
        ));

    return _pad(
        Row(
          children: <Widget>[loadingIndicator, loadingText],
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
        ),
        t: 20.0,
        b: 20.0);
  }

  @override
  void initState() {
    //在初始化状态中 准备第一页数据
    for (int i = 1; i <= pageCount; i++) {
      list.add('第$i条数据');
    }
    //在初始化状态的方法里 设置ListView的监听
    _scrollController.addListener(() {
      //判断 当滑动到最底部的时候，去加载更多的数据
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        //此时加载下一页数据
        _getMoreData();
      }
    });
  }

  Future<void> _doRefresh() async {
    //通过Future.delayed去延迟通知,
    //参数1：延时时间
    //参数2：到时后处理的逻辑
    await Future<Null>.delayed(Duration(microseconds: 2000), () {
      print('刷新');
      //让list中的数据+10条,可变的widget中可以使用 setstate(){} 函数
      setState(() {
        loadText = '加载中...';
        loadStatus = LoadingStatus.STATUS_LOADING;
        list.clear();
        for (int i = 1; i <= pageCount; i++) {
          list.add('我是刷新后的数据$i');
        }
        return null;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: new RefreshIndicator(
            child: new ListView.builder(
              itemCount: list.length + 1,
              itemBuilder: (BuildContext context, int index) {
                if (index == list.length) {
                  return _loadingView();
                } else {
                  return new Column(
                    children: <Widget>[
                      Center(
                        child: _pad(Text(list[index]), t: 20.0, b: 20.0),
                      ),
                      new Divider(height: 0.2)
                    ],
                  );
                }
              },
              controller: _scrollController,
            ),
            onRefresh: _doRefresh));
  }

  //获取完更多数据，然后给控件setState 让控件进行数据更新
  Future _getMoreData() async {
    if (loadStatus == LoadingStatus.STATUS_IDEL)
      //先设置状态，防止往下拉就直接加载数据
      setState(() {
        loadStatus = LoadingStatus.STATUS_LOADING;
      });
    List moreList;
    //假设总共数据就65条，做一个限制
    if (list.length < 45) {
      //异步准备数据
      moreList = await Future.delayed(Duration(seconds: 2), () async {
        return List.generate(pageCount, (i) {
          return '新增数据' + (list.length + i + 1).toString();
        });
      });
    }
    //准备完数据后，在设置状态

    setState(() {
      if (list.length < 45) {
        list.addAll(moreList);
        loadStatus = LoadingStatus.STATUS_IDEL;
        loadText = '加载中...';
      } else {
        //加载完毕
        loadText = '加载完毕';
        loadStatus = LoadingStatus.STATUS_COMPLETED;
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }
}
//        body: body1
