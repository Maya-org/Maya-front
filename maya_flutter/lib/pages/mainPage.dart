import 'package:flutter/material.dart';
import 'package:maya_flutter/api/API.dart';
import 'package:maya_flutter/api/models/Models.dart';
import 'package:maya_flutter/ui/AsyncButton.dart';
import 'package:provider/provider.dart';

import '../models/UserChangeNotifier.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String? _firstName;
  String? _lastName;
  List<ReservableEvent>? es;

  @override
  void initState() {
    super.initState();
  }

  Future<void> updateName() async {
    MayaUser? us = await user();
    if (us != null) {
      setState(() {
        _firstName = us.firstName;
        _lastName = us.lastName;
      });
    } else {
      setState(() {
        _firstName = "none";
        _lastName = "none";
      });
    }
  }

  Future<void> _getEvents() async {
    List<ReservableEvent>? events = await event();
    setState(() {
      es = events;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox.expand(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text("認証完了！！！！"),
            SizedBox(height: 10),
            Text("電話番号:"),
            Consumer<UserChangeNotifier>(
              builder: (context, user, _) => Text(user.user?.phoneNumber ?? ""),
            ),
            Text("UID:"),
            Consumer<UserChangeNotifier>(
              builder: (context, user, _) => Text(user.user?.uid ?? ""),
            ),
            SizedBox(height: 10),
            Text("名前:"),
            Text("${_firstName ?? ""} ${_lastName ?? ""}"),
            SizedBox(height: 10),
            AsyncButton(
                notLoadingButtonContent: Text("名前取得"), asyncTask: updateName, after: (r) {}),
            SizedBox(height: 10),
            Text("イベント一覧:"),
            Text(es?.toString() ?? ""),
            SizedBox(height: 10),
            AsyncButton(
                notLoadingButtonContent: Text("イベント取得"), asyncTask: _getEvents, after: (r) {}),
          ],
        )),
      ),
    );
  }
}
