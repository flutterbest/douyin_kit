import 'package:douyin_kit/douyin_kit.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String res = "";
  @override
  void initState() {
    super.initState();
    Douyin.instance.registerApp(clientKey: 'aw6sdvh96ng2gdsk');
    Douyin.instance.respStream().listen(_listenLogin);
  }

  void _listenLogin(dynamic data) {
    setState(() {
      res = data.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Douyin Kit Demo'),
        ),
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  Douyin.instance.auth(scope: ['user_info']);
                },
                child: const Text('授权'),
              ),
              Text(
                res,
                style: const TextStyle(color: Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
