import 'package:flutter/material.dart';
import 'package:maya_flutter/ui/ContainerDialog.dart';

class OKDialog extends ContainerDialog {
  final Function()? onOK;
  final String? okText;
  final bool? toClose;

  OKDialog(
      {Key? key,
      required Widget? body,
      required Widget? title,
      required this.onOK,
      this.okText,
      this.toClose})
      : super(key: key, body: body, title: title, actions: []);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: title,
      content: body,
      actions: [
        ElevatedButton(
            onPressed: () {
              if (toClose ?? false) {
                Navigator.pop(context);
              }
              onOK?.call();
            },
            child: Text(okText ?? "OK"))
      ],
    );
  }
}
