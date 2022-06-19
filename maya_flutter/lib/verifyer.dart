import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_firebase_recaptcha/firebase_recaptcha_verifier_modal.dart';
import 'package:maya_flutter/messages.i18n.dart';
import 'package:pinput/pinput.dart';
import 'package:universal_platform/universal_platform.dart';

import 'mainPage.dart';

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
                return PhoneVerifyPage(token: token);
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

class PhoneVerifyPage extends StatefulWidget {
  String token;

  PhoneVerifyPage({Key? key, required this.token}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PhoneVerifyPageState();
}

class _PhoneVerifyPageState extends State<PhoneVerifyPage> {
  final TextEditingController _controller = TextEditingController();
  String? _phoneNumber;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(const Messages().phone_auth_title),
        backgroundColor: Theme.of(context).backgroundColor,
      ),
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          TextField(
              controller: _controller,
              onChanged: (value) {
                setState(() {
                  _phoneNumber = value;
                });
              },
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9]{1,12}$'))],
              // 電話番号の正規表現
              decoration: InputDecoration(
                  labelText: const Messages().phone_auth_code_label,
                  hintText: const Messages().phone_auth_code_hint)),
          const SizedBox(height: 10),
          ElevatedButton(
            child: Text(const Messages().phone_auth_code_button),
            onPressed: _phoneNumber == null
                ? null
                : () async {
                    String localPhoneNumber = '+81 ${_phoneNumber!.substring(1)}';

                    if (UniversalPlatform.isWeb) {
                      FirebaseAuth.instance.signInWithPhoneNumber(localPhoneNumber);
                    } else {
                      await FirebaseAuth.instance.verifyPhoneNumber(
                          phoneNumber: localPhoneNumber,
                          verificationCompleted: (PhoneAuthCredential credential) async {
                            await FirebaseAuth.instance.signInWithCredential(credential);
                          },
                          verificationFailed: (FirebaseAuthException ex) {
                            // Handle error here.
                            late String bodyString;
                            switch (ex.code) {
                              case 'invalid-phone-number':
                                bodyString = const Messages().phone_auth_error_wrong_phone_number;
                                break;
                              default:
                                bodyString =
                                    "${const Messages().phone_auth_error_message}\nエラーコード: ${ex.code}";
                            }

                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text(const Messages().phone_auth_error_title),
                                    content: Center(
                                      child: Text(bodyString),
                                    ),
                                    actions: [
                                      ElevatedButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text(const Messages().phone_auth_error_return))
                                    ],
                                  );
                                });
                          },
                          codeSent: (String verificationId, int? resendToken) {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return PhoneVerifyCodeInputDialog(
                                    verificationId: verificationId,
                                  );
                                });
                          },
                          codeAutoRetrievalTimeout: (String verificationId) {
                            // Do nothing
                          },
                          timeout: const Duration(seconds: 30) // Android only 30秒は自動入力を有効化する
                          );
                    }
                  },
          )
        ]),
      ),
    );
  }
}

class PhoneVerifyCodeInputDialog extends StatefulWidget {
  String verificationId;

  PhoneVerifyCodeInputDialog({Key? key, required this.verificationId});

  @override
  State<StatefulWidget> createState() => _PhoneVerifyCodeInputDialogState();
}

class _PhoneVerifyCodeInputDialogState extends State<PhoneVerifyCodeInputDialog> {
  @override
  Widget build(BuildContext context) {
    return Pinput(
        length: 4,
        pinputAutovalidateMode: PinputAutovalidateMode.disabled,
        onSubmitted: (String value) async {
          // Login
          PhoneAuthCredential credential =
              PhoneAuthProvider.credential(verificationId: widget.verificationId, smsCode: value);
          try {
            await FirebaseAuth.instance.signInWithCredential(credential);

            // 正常にログインできた
            Navigator.of(this.context).pushReplacement(MaterialPageRoute(builder: (context) {
              return const MainPage();
            }));
          } on FirebaseAuthException catch (e) {
            late String bodyString;
            switch (e.code) {
              case "invalid-verification-code":
                // 打ち込まれたコードが間違っている
                bodyString = const Messages().phone_auth_input_wrong_number;
                break;
              default:
                // その他のエラー
                bodyString = "${const Messages().phone_auth_error_title}\nエラーコード: ${e.code}";
                break;
            }

            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text(const Messages().phone_auth_error_title),
                    content: Center(
                      child: Text(bodyString),
                    ),
                    actions: [
                      ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(const Messages().phone_auth_error_return))
                    ],
                  );
                });
          }
        });
  }
}
