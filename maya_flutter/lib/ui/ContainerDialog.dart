import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ContainerDialog extends StatelessWidget {
  Widget? body;
  Widget? title;
  List<Widget>? actions;

  ContainerDialog({this.body, this.title, this.actions, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: title,
      content: Container(
        child: body,
      ),
      actions: actions,
    );
  }
}
