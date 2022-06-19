import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SimpleDialog extends StatefulWidget {
  Widget? body;
  Widget? title;
  List<Widget>? actions;

  SimpleDialog({this.body, this.title, this.actions, Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SimpleDialogState();
}

class _SimpleDialogState extends State<SimpleDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: widget.title,
      content: widget.body,
      actions: widget.actions,
    );
  }
}
