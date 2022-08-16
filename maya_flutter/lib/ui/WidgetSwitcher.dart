import 'package:flutter/material.dart';

class WidgetSwitcher extends StatefulWidget {
  final Widget trueWidget;
  final Widget falseWidget;
  bool value;

  WidgetSwitcher({required this.trueWidget,required this.falseWidget, this.value = false, Key? key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _WidgetSwitcherState();
}

class _WidgetSwitcherState extends State<WidgetSwitcher> {
  @override
  Widget build(BuildContext context) {
    return widget.value ? widget.trueWidget : widget.falseWidget;
  }
}
