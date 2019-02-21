import 'package:flutter/material.dart';

//使用 MethodChannel 必须导
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter & Android'),
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

  int count = 0;
  static const androidplatform = const MethodChannel("Flutter_love_android");
  Future<dynamic> result;
  var imageUrl;

  @override
  Widget build(BuildContext context) {
    var testColumn = new Column(
      children: <Widget>[],
    );

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: _genButtons(),
        ));
  }

  Column _genButtons() {
    return new Column(children: <Widget>[
      FlatButton(
        onPressed: () {
          androidplatform.invokeMethod('showToast');
        },
        child: Text(
          "调用Android吐司_不携带参数_不返回",
          style: TextStyle(color: Colors.blue, fontSize: 12.0),
        ),
        color: Colors.yellow,
      ),
      FlatButton(
        onPressed: () {
          androidplatform.invokeMethod('showToast', {'msg': '来自flutter的问候'});
        },
        child: Text(
          "调用Android吐司_携带参数_不返回",
          style: TextStyle(color: Colors.blue, fontSize: 12.0),
        ),
        color: Colors.pink,
      ),
      FlatButton(
        onPressed: () {
          result =
              androidplatform.invokeMethod('showToast', {'index': (count++)%7});
          result.then((url) {
            imageUrl = url;
            _push2Image(imageUrl);
          });
        },
        child: Text(
          "获取Android中对应索引的Banner图",
          style: TextStyle(color: Colors.blue, fontSize: 12.0),
        ),
        color: Colors.purple,
      ),

    ]);
  }

  void _push2Image(imageUrl) {
    Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context){
        return Scaffold(
          appBar: new AppBar(title: Text('hi friend,how are you'),
          ),body:Center(child:Image(image:NetworkImage(imageUrl))));

    }));
  }
}
