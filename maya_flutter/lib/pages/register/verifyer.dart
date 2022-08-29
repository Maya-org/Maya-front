import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:maya_flutter/messages.i18n.dart';
import 'package:maya_flutter/ui/DefaultAppBar.dart';
import 'package:maya_flutter/ui/StyledText.dart';
import 'package:maya_flutter/ui/UI.dart';
import 'package:universal_platform/universal_platform.dart';

class PhoneVerifier extends StatefulWidget {
  const PhoneVerifier({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PhoneVerifierState();
}

class _PhoneVerifierState extends State<PhoneVerifier> {
  final TextEditingController _controller = TextEditingController();
  String _phoneNumber = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: defaultAppBar(const Messages().phone_auth_title),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          StyledTextWidget.mdFromAsset("assets/verify.md"),
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
            onPressed: _phoneNumber.isEmpty
                ? null
                : () async {
                    showFullScreenLoadingCircular(context);

                    String localPhoneNumber = '+81 ${_phoneNumber.substring(1)}';
                    if (UniversalPlatform.isWeb) {
                      // webではsignInWithPhoneNumberを使う
                      ConfirmationResult res = await FirebaseAuth.instance.signInWithPhoneNumber(
                        localPhoneNumber,
                      );

                      Navigator.of(this.context, rootNavigator: true).pop();  // フルスクリーンローディングを閉じる

                      showDialog(
                          context: context,
                          builder: (context) {
                            return PhoneVerifyCodeInputDialog(
                              function: (code) async {
                                await res.confirm(code);
                              },
                            );
                          });
                    } else {
                      // NativeではverifyPhoneNumberを使う
                      await FirebaseAuth.instance.verifyPhoneNumber(
                          phoneNumber: localPhoneNumber,
                          verificationCompleted: (PhoneAuthCredential credential) async {
                            await FirebaseAuth.instance.signInWithCredential(credential);
                            Navigator.of(this.context).pushReplacementNamed("/main");
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

                            Navigator.of(context, rootNavigator: true).pop();
                            showOKDialog(this.context,
                                title: Text(const Messages().phone_auth_error_title),
                                body: Center(
                                  child: Text(bodyString),
                                ), onOK: () {
                              Navigator.of(context).pop();
                            }, okText: const Messages().phone_auth_error_return);
                          },
                          codeSent: (String verificationId, int? resendToken) {
                            Navigator.of(context, rootNavigator: true).pop();
                            showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (context) {
                                  return PhoneVerifyCodeInputDialog(
                                    function: (code) async {
                                      PhoneAuthCredential credential =
                                          PhoneAuthProvider.credential(
                                              verificationId: verificationId, smsCode: code);
                                      await FirebaseAuth.instance
                                          .signInWithCredential(credential);
                                    },
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
            child: Text(const Messages().phone_auth_code_button),
          )
        ]),
      ),
    );
  }
}

class PhoneVerifyCodeInputDialog extends StatefulWidget {
  Future<void> Function(String code) function;

  PhoneVerifyCodeInputDialog({Key? key, required this.function}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PhoneVerifyCodeInputDialogState();
}

class _PhoneVerifyCodeInputDialogState extends State<PhoneVerifyCodeInputDialog> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(const Messages().phone_auth_input_code_title),
      content: TextFormField(
        controller: _controller,
        keyboardType: TextInputType.number,
        // 電話番号の正規表現
        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9]{1,6}$'))],
      ),
      actions: [
        ElevatedButton(
            onPressed: () async {
              String value = _controller.value.text;
              // Login
              showFullScreenLoadingCircular(context);
              widget.function(value).then((credential) {
                // 正常にログインできたら
                Navigator.of(context).pushReplacementNamed("/main");
              });
            },
            child: const Text("認証"))
      ],
    );
  }
}
