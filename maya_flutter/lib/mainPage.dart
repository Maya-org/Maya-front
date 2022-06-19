import 'package:firebase_auth/firebase_auth.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: Text(const Messages().app_title),
      ),
      body: Container(
        child: Column(children: [
            const Text("認証完了！！！！"),
            SizedBox(height: 10),
            Text("電話番号:"),
            Text(FirebaseAuth.instance.currentUser?.phoneNumber ?? ""),
          ],
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
        ),
        height: double.infinity,
        width: double.infinity,
      ),
    );
  }
}
