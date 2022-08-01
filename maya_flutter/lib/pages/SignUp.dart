import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:maya_flutter/messages.i18n.dart';
import 'package:maya_flutter/models/UserChangeNotifier.dart';
import 'package:provider/provider.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  @override
  void initState() {
    super.initState();
  }

  // TODO Restyle
  @override
  Widget build(BuildContext context) {
    User? user = Provider.of<UserChangeNotifier>(context, listen: true).user;
    if(user!=null){
      // TODO Firebaseにいるユーザーがすべて名前登録を終えている構造にする
      Future.microtask(() => Navigator.pushReplacementNamed(context, "/main"));
    }

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(const Messages().sign_up_message),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed("/register/phoneVerifier");
                },
                child: const Text("Login"))
          ],
        ),
      ),
    );
  }
}
