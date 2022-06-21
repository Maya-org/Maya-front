import 'package:flutter/material.dart';
import 'package:maya_flutter/ui/ContainerDialog.dart';

class OKDialog extends ContainerDialog {
  Function()? onOK;
  String? okText;
  bool? toClose;

  OKDialog(
      {Key? key, required Widget? body,
      required Widget? title,
      required this.onOK,
      this.okText,
      this.toClose})
      : super(key: key, body: body, title: title, actions: []);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: title,
      content: Container(
        child: body,
      ),
      actions: [
        ElevatedButton(
            onPressed: () {
              if (toClose?? false) Navigator.pop(context);
              onOK?.call();
            },
            child: Text(okText ?? "OK"))
      ],
    );
  }
}
