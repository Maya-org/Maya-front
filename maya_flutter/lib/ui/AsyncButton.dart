import 'package:flutter/material.dart';

import 'UI.dart';
import 'WidgetSwitcher.dart';

/// Asyncでタスクを実行しているときには、読み込み中のくるくるマークを表示する
class AsyncButton<R> extends StatefulWidget {
  final Widget notLoadingButtonContent;
  final Future<R> Function() asyncTask;
  final void Function(dynamic) after;
  final bool isFullScreenLoading;

  const AsyncButton(
      {Key? key,
      required this.notLoadingButtonContent,
      required this.asyncTask,
      this.isFullScreenLoading = true,
      required this.after})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _AsyncButtonState();
}

class _AsyncButtonState<R> extends State<AsyncButton<R>> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return WidgetSwitcher(
      falseWidget: ElevatedButton(
        onPressed: () async {
          await _onPressed(context);
        },
        child: widget.notLoadingButtonContent,
      ),
      trueWidget: const CircularProgressIndicator(),
      value: _isLoading && !widget.isFullScreenLoading,
    );
  }

  Future<void> _onPressed(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });

    if (widget.isFullScreenLoading) {
      showFullScreenLoadingCircular(context);
    }

    R r = await widget.asyncTask();

    setState(() {
      _isLoading = false;
    });

    Navigator.of(this.context, rootNavigator: true).pop(); // FullScreenLoadingCircularを閉じる

    _call(r);
  }

  void _call(R r) {
    widget.after(r);
  }
}
