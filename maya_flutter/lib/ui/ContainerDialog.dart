import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ContainerDialog extends StatelessWidget {
  final Widget? body;
  final Widget? title;
  final List<Widget>? actions;

  const ContainerDialog({this.body, this.title, this.actions, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: title,
      content: body,
      actions: actions,
    );
  }
}
