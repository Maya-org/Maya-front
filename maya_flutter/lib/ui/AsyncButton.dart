import 'package:flutter/material.dart';

import 'WidgetSwitcher.dart';

/// Asyncでタスクを実行しているときには、読み込み中のくるくるマークを表示する
class AsyncButton extends StatefulWidget {
  final Widget notLoadingButtonContent;
  final Future<dynamic> Function() task;

  AsyncButton({Key? key, required this.notLoadingButtonContent, required this.task})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _AsyncButtonState();
}

class _AsyncButtonState extends State<AsyncButton> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return WidgetSwitcher(
      falseWidget: ElevatedButton(
        onPressed: _onPressed,
        child: widget.notLoadingButtonContent,
      ),
      trueWidget: const CircularProgressIndicator(),
      value: _isLoading,
    );
  }

  void _onPressed(){
    setState(() {
      _isLoading = true;
    });
    Future(() async {
      await widget.task();
      setState(() {
        _isLoading = false;
      });
    });
  }
}