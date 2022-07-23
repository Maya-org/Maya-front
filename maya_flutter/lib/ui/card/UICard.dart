import 'package:flutter/material.dart';

class UICard extends StatelessWidget {
  final Widget title;
  final Widget? body;
  final void Function()? onTap;
  final Widget? top;

  const UICard({
    Key? key,
    required this.title,
    this.body,
    this.onTap,
    this.top,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        elevation: 3,
        child: Column(
          children: [
            if (top != null) Expanded(child: top!),
            ListTile(
              title: title,
              subtitle: body,
              contentPadding: const EdgeInsets.all(10),
            ),
          ],
        ),
      ),
    );
  }
}
