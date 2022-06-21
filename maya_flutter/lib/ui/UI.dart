import 'package:flutter/material.dart';
import 'package:maya_flutter/ui/ContainerDialog.dart';
import 'package:maya_flutter/ui/OKDialog.dart';

import 'FullScreenLoadingCircular.dart';

void showContainerDialog(BuildContext context,
    {Widget? title, Widget? body, List<Widget>? actions}) {
  showDialog(
      context: context,
      builder: (context) {
        return ContainerDialog(title: title, body: body, actions: actions);
      });
}

void showOKDialog(BuildContext context,
    {Widget? title, Widget? body, Function()? onOK, String? okText, bool? toClose}) {
  showDialog(
      context: context,
      builder: (ctx) {
        return OKDialog(
          title: title,
          body: body,
          onOK: onOK,
          okText: okText,
          toClose: toClose ?? true,
        );
      });
}

void showFullScreenLoadingCircular(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return FullScreenLoadingCircular();
    },
    barrierColor: Colors.black.withOpacity(0.5),
  );
}
