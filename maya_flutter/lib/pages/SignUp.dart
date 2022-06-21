import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:maya_flutter/api/API.dart';
import 'package:maya_flutter/messages.i18n.dart';

import 'mainPage.dart';
import 'verifyer.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<SignUpPage> createState() => _TitlePageState();
}

class _TitlePageState extends State<SignUpPage> {
  @override
  void initState() {
    super.initState();
    Future(() async {
      await autoRedirect();
    });
  }

  Future<void> autoRedirect() async {
    if (FirebaseAuth.instance.currentUser != null && await user() != null) {
      // 認証済みの場合はメインページに遷移
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
        return const MainPage();
      }));
    }
  }

  // TODO Restyle
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(const Messages().sign_up_message),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
                    // 電話認証にすっとばす
                    return PhoneVerifier();
                  }));
                },
                child: const Text("Login"))
          ],
        ),
      ),
    );
  }
}
