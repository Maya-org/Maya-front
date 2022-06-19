import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:maya_flutter/firebase_options.dart';
import 'package:maya_flutter/mainPage.dart';
import 'package:maya_flutter/messages.i18n.dart';
import 'package:maya_flutter/verifyer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MayaApp());
}

class MayaApp extends StatelessWidget {
  const MayaApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: const Messages().app_title,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TitlePage(title: const Messages().page_title),
    );
  }
}

class TitlePage extends StatefulWidget {
  const TitlePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<TitlePage> createState() => _TitlePageState();
}

class _TitlePageState extends State<TitlePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Theme.of(context).backgroundColor,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text("Try Login"),
            ElevatedButton(
                onPressed: () {
                  if (FirebaseAuth.instance.currentUser == null) {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
                      return PhoneVerifier();
                    }));
                  } else {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
                      return const MainPage();
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
