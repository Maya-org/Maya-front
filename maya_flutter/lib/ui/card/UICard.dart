import 'package:flutter/material.dart';

class UICard extends StatelessWidget {
  final Widget title;
  final Widget? body;
  final void Function()? onTap;
  final Widget? top;
  final EdgeInsets? margin;
  final bool? toExpandTop;

  const UICard(
      {Key? key,
      required this.title,
      this.body,
      this.onTap,
      this.top,
      this.margin,
      this.toExpandTop})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        margin: margin,
        elevation: 3,
        child: Column(
          children: [
            if (top != null && (toExpandTop ?? false)) Expanded(child: top!),
            if (top != null && !(toExpandTop ?? false)) top!,
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
