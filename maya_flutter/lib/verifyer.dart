import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_recaptcha/firebase_recaptcha_verifier_modal.dart';
import 'package:maya_flutter/messages.i18n.dart';

class PhoneVerifier extends StatefulWidget {
  const PhoneVerifier({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PhoneVerifierState();
}

class _PhoneVerifierState extends State<PhoneVerifier> {
  @override
  void initState() {
    super.initState();
    Future(() {
      onLogin(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }

  void onLogin(BuildContext context) {
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
      return _FirebaseStack();
    }));
  }
}

class _FirebaseStack extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _FirebaseStackState();
}

class _FirebaseStackState extends State<_FirebaseStack> {
  bool _toShowLoading = true;

  @override
  Widget build(BuildContext context) {
    var firebaseConfig = {
      'apiKey': Firebase.app().options.apiKey,
      'authDomain': "localhost",
      'projectId': Firebase.app().options.projectId,
      'storageBucket': Firebase.app().options.storageBucket!,
      'messagingSenderId': Firebase.app().options.messagingSenderId,
      'appId': Firebase.app().options.appId
    };

    return Stack(
      children: [
        FirebaseRecaptchaVerifierModal(
            firebaseConfig: firebaseConfig,
            onVerify: (String token) {
              print("Token: $token");
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
                return PhoneVerifyCodeInputPage(token: token);
              }));
            },
            onError: () {
              print("Error");
            },
            onFullChallenge: () {
              print("FullChallenge");
              setState(() {
                _toShowLoading = false;
              });
            },
            onLoad: () {
              print("Load");
            },
            attemptInvisibleVerification: true),
        if (_toShowLoading)
          Expanded(
              child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  const Messages().reCaptcha_loading_text,
                  style: Theme.of(context).textTheme.headline4,
                ),
                const SizedBox(
                  height: 10,
                ),
                const CircularProgressIndicator(
                  color: Colors.blue,
                  strokeWidth: 3,
                  backgroundColor: Colors.white,
                ),
              ],
            )),
          ))
      ],
    );
  }
}

class PhoneVerifyCodeInputPage extends StatefulWidget {
  String token;

  PhoneVerifyCodeInputPage({Key? key, required this.token}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PhoneVerifyCodeInputPageState();
}

class _PhoneVerifyCodeInputPageState extends State<PhoneVerifyCodeInputPage> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(const Messages().phone_auth_title),
        backgroundColor: Theme.of(context).backgroundColor,
      ),
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          Text(widget.token),
          TextField(
            controller: _controller,
            onChanged: (value) {
              print("onChanged: $value");
            },
          )
        ]),
      ),
    );
  }
}
