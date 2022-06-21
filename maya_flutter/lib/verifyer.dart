import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:maya_flutter/messages.i18n.dart';
import 'package:maya_flutter/ui/ContainerDialog.dart';
import 'package:maya_flutter/ui/UI.dart';
import 'package:maya_flutter/ui/WidgetSwitcher.dart';
import 'package:pinput/pinput.dart';
import 'package:universal_platform/universal_platform.dart';

import 'pages/mainPage.dart';

class PhoneVerifier extends StatefulWidget {
  PhoneVerifier({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PhoneVerifierState();
}

class _PhoneVerifierState extends State<PhoneVerifier> {
  final TextEditingController _controller = TextEditingController();
  String _phoneNumber = "";
  bool _isLoading = false;

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
          WidgetSwitcher(
              value: _isLoading,
              trueWidget: const CircularProgressIndicator(),
              falseWidget: ElevatedButton(
                child: Text(const Messages().phone_auth_code_button),
                onPressed: _phoneNumber.isEmpty
                    ? null
                    : () async {
                        setState(() {
                          _isLoading = true;
                        });
                        String localPhoneNumber = '+81 ${_phoneNumber.substring(1)}';
                        if (UniversalPlatform.isWeb) {
                          ConfirmationResult res =
                              await FirebaseAuth.instance.signInWithPhoneNumber(localPhoneNumber);
                          showDialog(
                              context: context,
                              builder: (context) {
                                return PhoneVerifyCodeInputDialog(
                                  function: (code) async {
                                    return (await res.confirm(code))
                                        .credential!; // TODO credential is optional
                                  },
                                );
                              });
                        } else {
                          await FirebaseAuth.instance.verifyPhoneNumber(
                              phoneNumber: localPhoneNumber,
                              verificationCompleted: (PhoneAuthCredential credential) async {
                                print('verificationCompleted');
                                await FirebaseAuth.instance.signInWithCredential(credential);
                                Navigator.of(this.context)
                                    .pushReplacement(MaterialPageRoute(builder: (context) {
                                  return const MainPage();
                                }));
                              },
                              verificationFailed: (FirebaseAuthException ex) {
                                print('verificationFailed');
                                // Handle error here.
                                late String bodyString;
                                switch (ex.code) {
                                  case 'invalid-phone-number':
                                    bodyString =
                                        const Messages().phone_auth_error_wrong_phone_number;
                                    break;
                                  default:
                                    bodyString =
                                        "${const Messages().phone_auth_error_message}\nエラーコード: ${ex.code}";
                                }

                                showOKDialog(this.context,
                                    title: Text(const Messages().phone_auth_error_title),
                                    body: Center(
                                      child: Text(bodyString),
                                    ), onOK: () {
                                  Navigator.of(context).pop();
                                }, okText: const Messages().phone_auth_error_return);
                              },
                              codeSent: (String verificationId, int? resendToken) {
                                print('codeSent');
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return PhoneVerifyCodeInputDialog(
                                        function: (code) {
                                          return Future.value(PhoneAuthProvider.credential(
                                              verificationId: verificationId, smsCode: code));
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
              ))
        ]),
      ),
    );
  }
}

class PhoneVerifyCodeInputDialog extends StatefulWidget {
  Future<AuthCredential> Function(String) function;

  PhoneVerifyCodeInputDialog({Key? key, required this.function});

  @override
  State<StatefulWidget> createState() => _PhoneVerifyCodeInputDialogState();
}

class _PhoneVerifyCodeInputDialogState extends State<PhoneVerifyCodeInputDialog> {
  @override
  Widget build(BuildContext context) {
    return ContainerDialog(
      title: Text(const Messages().phone_auth_input_code_title),
      body: Pinput(
          length: 6,
          pinputAutovalidateMode: PinputAutovalidateMode.disabled,
          onCompleted: (String value) async {
            print('onSubmitted');
            // Login
            AuthCredential credential = await widget.function(value);
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

              showOKDialog(this.context,
                  title: Text(const Messages().phone_auth_error_title),
                  body: Center(
                    child: Text(bodyString),
                  ), onOK: () {
                Navigator.of(this.context).pop();
              }, okText: const Messages().phone_auth_error_return);
            }
          }),
    );
  }
}