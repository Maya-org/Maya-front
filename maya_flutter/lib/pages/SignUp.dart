import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:maya_flutter/api/API.dart';
import 'package:maya_flutter/messages.i18n.dart';
import 'package:maya_flutter/models/UserChangeNotifier.dart';
import 'package:provider/provider.dart';

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
  }

  Future<void> checkAutoRedirect(BuildContext context) async {
    print('checkAutoRedirect');
    UserChangeNotifier notifier = Provider.of<UserChangeNotifier>(context, listen: true);
    if (notifier.user != null && await user() != null) {
      // TODO なんだこれ
      Navigator.pushReplacementNamed(this.context, "/debug");
    }
  }

  // TODO Restyle
  @override
  Widget build(BuildContext context) {
    checkAutoRedirect(context);
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
