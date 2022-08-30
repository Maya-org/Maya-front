import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:maya_flutter/models/UserChangeNotifier.dart';
import 'package:maya_flutter/ui/StyledText.dart';
import 'package:provider/provider.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool _isInited = false;
  bool _checked = false;


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_isInited) {
        _isInited = true;
        if (Provider.of<UserChangeNotifier>(context, listen: false).user != null){
          Navigator.pushReplacementNamed(context, "/loading");
          return;
        }
        Provider.of<UserChangeNotifier>(context, listen: false).addListener(() {
          if (Provider.of<UserChangeNotifier>(context, listen: false).user != null){
            Navigator.pushReplacementNamed(context, "/loading");
          }
        });
      }
    });
  }

  // TODO Restyle
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            StyledTextWidget.mdFromAsset("assets/signUp.md"),
            Row(
              children: [
                Checkbox(value: _checked, onChanged: (bool? b){
                  setState(() {
                    _checked = b!;
                  });
                }),
                const Text("上記の規約に同意します。")
              ],
            ),
            ElevatedButton(
                onPressed: _checked ? () {
                  Navigator.of(context).pushReplacementNamed("/register/phoneVerifier");
                } : null,
                child: const Text("新規登録"))
          ],
        ),
      ),
    );
  }
}
