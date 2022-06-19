import 'package:flutter/material.dart';
import 'package:maya_flutter/messages.i18n.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text(const Messages().app_title),), body: const Text("認証完了！！！！"),);
  }
}
