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
            onPressed: _phoneNumber.isEmpty ? null : _verify,
            child: Text(const Messages().phone_auth_code_button),
          )
        ]),
      ),
    );
  }

  Future<void> _verify() async {
    showFullScreenLoadingCircular(context);

    String localPhoneNumber = '+81 ${_phoneNumber.substring(1)}';
    if (UniversalPlatform.isWeb) {
      ConfirmationResult res;
      try {
        // webではsignInWithPhoneNumberを使う
        res = await FirebaseAuth.instance.signInWithPhoneNumber(
          localPhoneNumber,
        );
      } on FirebaseAuthException catch (e) {
        closeFullScreenLoadingCircular();
        handleAuthError(e);
        return;
      }
      closeFullScreenLoadingCircular(); // フルスクリーンローディングを閉じる

      showDialog(
          context: context,
          builder: (context) {
            return PhoneVerifyCodeInputDialog(
              function: (code) => signInWithPhoneNumber(res, code),
            );
          });
    } else {
      // NativeではverifyPhoneNumberを使う
      await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: localPhoneNumber,
          verificationCompleted: (PhoneAuthCredential credential) async {
            closeFullScreenLoadingCircular(); // フルスクリーンローディングを閉じる
            FirebaseAuthException? ex = await signInWithCredential(credential);
            if (ex == null) {
              if (!mounted) return;
              Navigator.of(context).pushReplacementNamed("/main");
            } else {
              handleAuthError(ex);
            }
          },
          verificationFailed: (FirebaseAuthException ex) {
            closeFullScreenLoadingCircular(); // フルスクリーンローディングを閉じる
            handleAuthError(ex);
          },
          codeSent: (String verificationId, int? resendToken) {
            closeFullScreenLoadingCircular(); // フルスクリーンローディングを閉じる
            showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) {
                  return PhoneVerifyCodeInputDialog(
                    function: (code) async {
                      PhoneAuthCredential credential = PhoneAuthProvider.credential(
                          verificationId: verificationId, smsCode: code);
                      return await signInWithCredential(credential);
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
  }

  Future<FirebaseAuthException?> signInWithPhoneNumber(ConfirmationResult res, String code) async {
    try {
      await res.confirm(code);
      return null;
    } on FirebaseAuthException catch (e) {
      return e;
    }
  }

  Future<FirebaseAuthException?> signInWithCredential(PhoneAuthCredential credential) async {
    try {
      await FirebaseAuth.instance.signInWithCredential(credential);
      return null;
    } on FirebaseAuthException catch (e) {
      return e;
    }
  }

  void closeFullScreenLoadingCircular() {
    if (!mounted) return;
    Navigator.of(context, rootNavigator: true).pop(); // フルスクリーンローディングを閉じる
  }

  void handleAuthError(FirebaseAuthException ex) {
    // Handle error here.
    late String bodyString;
    switch (ex.code) {
      case 'invalid-phone-number':
        bodyString = const Messages().phone_auth_error_wrong_phone_number;
        break;
      default:
        bodyString = "${const Messages().phone_auth_error_message}\nエラーコード: ${ex.code}";
    }

    showOKDialog(
      context,
      title: Text(const Messages().phone_auth_error_title),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Text(bodyString),
          ),
        ],
      ),
      okText: const Messages().phone_auth_error_return,
    );
  }
}

class PhoneVerifyCodeInputDialog extends StatefulWidget {
  Future<FirebaseAuthException?> Function(String code) function;

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
              showFullScreenLoadingCircular(context); // フルスクリーンローディングを開く
              String value = _controller.value.text;
              // Login
              widget.function(value).then((ex) {
                if (ex == null) {
                  // 正常にログインできたら
                  Navigator.of(context).pushReplacementNamed("/main");
                } else {
                  // ログインできなかったら
                  closeFullScreenLoadingCircular(); // フルスクリーンローディングを閉じる
                  handleAuthError(ex);
                }
              });
            },
            child: const Text("認証"))
      ],
    );
  }

  void closeFullScreenLoadingCircular() {
    if (!mounted) return;
    Navigator.of(context, rootNavigator: true).pop(); // フルスクリーンローディングを閉じる
  }

  void handleAuthError(FirebaseAuthException ex) {
    // Handle error here.
    late String bodyString;
    switch (ex.code) {
      case 'invalid-phone-number':
        bodyString = const Messages().phone_auth_error_wrong_phone_number;
        break;
      default:
        bodyString = "${const Messages().phone_auth_error_message}\nエラーコード: ${ex.code}";
    }

    showOKDialog(
      context,
      title: Text(const Messages().phone_auth_error_title),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Text(bodyString),
          ),
        ],
      ),
      okText: const Messages().phone_auth_error_return,
    );
  }
}
