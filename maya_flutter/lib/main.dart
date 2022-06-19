import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_recaptcha/firebase_recaptcha_verifier_modal.dart';
import 'package:maya_flutter/firebase_options.dart';
import 'package:maya_flutter/messages.i18n.dart';

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
  String? _token;

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
            Text("Try Login"),
            ElevatedButton(
                onPressed: () {
                  onLogin(context);
                },
                child: Text("Login")),

            if (_token != null)
              Text("Token: $_token"),
          ],
        ),
      ),
    );
  }

  void onLogin(BuildContext context) {
    var firebaseConfig = {
      'apiKey': Firebase.app().options.apiKey,
      'authDomain': "localhost",
      'projectId': Firebase.app().options.projectId,
      'storageBucket': Firebase.app().options.storageBucket!,
      'messagingSenderId': Firebase.app().options.messagingSenderId,
      'appId': Firebase.app().options.appId
    };

    showDialog(
        context: context,
        builder: (context) {
          print('config: $firebaseConfig');
          return FirebaseRecaptchaVerifierModal(
              firebaseConfig: firebaseConfig,
              onVerify: (String token) {
                print("Token: $token");
                Navigator.pop(context);
                setState(() {
                  _token = token;
                });
              },
              onError: () {
                print("Error");
              },
              onFullChallenge: () {
                print("FullChallenge");
              },
              attemptInvisibleVerification: true);
        });
  }
}
