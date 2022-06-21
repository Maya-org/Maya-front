import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../verifyer.dart';
import 'mainPage.dart';

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
    if (FirebaseAuth.instance.currentUser != null) {
      // 認証済みの場合はメインページに遷移
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
        return const MainPage();
      }));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text("Try Login"),
            ElevatedButton(
                onPressed: () {
                  if (FirebaseAuth.instance.currentUser != null) {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
                      return const MainPage();
                    }));
                  } else {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
                      return PhoneVerifier();
                    }));
                  }
                },
                child: const Text("Login"))
          ],
        ),
      ),
    );
  }
}
