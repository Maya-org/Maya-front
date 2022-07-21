import 'package:flutter/material.dart';

class UICard extends StatelessWidget {
  final Widget title;
  final Widget? body;
  final void Function()? onTap;
  const UICard({
    Key? key,
    required this.title,
    this.body,
    this.onTap,
  }) : super(key: key);

  List<Widget> _list() {
    return [title, body].whereType<Widget>().toList();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        elevation: 3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: _list(),
        ),
      ),
    );
  }
}
