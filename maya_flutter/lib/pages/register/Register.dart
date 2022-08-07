import 'package:flutter/material.dart';
import 'package:maya_flutter/api/APIResponse.dart';
import 'package:maya_flutter/messages.i18n.dart';
import 'package:maya_flutter/ui/APIResponseHandler.dart';
import 'package:maya_flutter/ui/UI.dart';

import '../../api/API.dart';
import '../../api/models/Models.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController _first_name_controller = TextEditingController();
  final TextEditingController _last_name_controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(const Messages().sign_up_name_register),
            Expanded(
                child: Column(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      TextField(
                        controller: _first_name_controller,
                        decoration: InputDecoration(
                          labelText: const Messages().sign_up_name_first_name,
                        ),
                      ),
                      TextField(
                        controller: _last_name_controller,
                        decoration: InputDecoration(
                          labelText: const Messages().sign_up_name_last_name,
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  child: Text(const Messages().sign_up_name_submit),
                  onPressed: () {
                    onRegister();
                  },
                )
              ],
            ))
          ],
        ),
      ),
    );
  }

  void onRegister() {
    final first_name = _first_name_controller.text;
    final last_name = _last_name_controller.text;
    if (first_name.isEmpty || last_name.isEmpty) {
      showOKDialog(context, title: Text(const Messages().sign_up_name_register_not_inputted));
      return;
    }

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(const Messages().sign_up_name_register_confirm),
            content:
                Text(const Messages().sign_up_name_register_confirm_body(first_name, last_name)),
            actions: [
              ElevatedButton(
                child: Text(const Messages().sign_up_name_confirm),
                onPressed: () async {
                  Navigator.pop(context);
                  await submit(context, first_name, last_name);
                },
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(const Messages().sign_up_name_edit),
                style: ElevatedButton.styleFrom(
                  primary: Colors.red,
                  onPrimary: Colors.white,
                ),
              )
            ],
          );
        });
  }

  Future<void> submit(BuildContext context, String firstName, String lastName) async {
    showFullScreenLoadingCircular(context);
    APIResponse<bool?> r = await rg(context, firstName, lastName);
    Navigator.of(this.context, rootNavigator: true).pop(); // FullScreenLoadingCircularを閉じる
    handle<bool?, void>(
        r,
        (p0) => showOKDialog(this.context,
                title: Text(const Messages().sign_up_name_register_complete_message_title),
                body: Text(const Messages().sign_up_name_register_complete_message_body), onOK: () {
              Navigator.of(context).pushReplacementNamed("/main");
            }),
        (res, displayString) => showOKDialog(this.context,
            title: Text(const Messages().sign_up_name_register_failed_message_title),
            body: Text(
                const Messages().sign_up_name_register_failed_message_body(r.displayMessage))));
  }

  Future<APIResponse<bool?>> rg(BuildContext context, String firstName, String lastName) async {
    return await register(MayaUser(firstName, lastName, TimeStamp.now()));
  }
}
