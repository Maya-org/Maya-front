import 'package:flutter/material.dart';
import 'package:maya_flutter/ui/APIResponseHandler.dart';

import '../../api/APIResponse.dart';

class CheckPostPage extends StatefulWidget {
  final APIResponse<bool?> response;

  const CheckPostPage({Key? key, required this.response}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CheckPostPageState();
}

class _CheckPostPageState extends State<CheckPostPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('チェックイン/チェックアウト結果'),
      ),
      body: Center(
        child: Column(
          children: [
            Text(_bodyString()),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushReplacementNamed('/main');
              },
              child: const Text('戻る'),
            ),
          ],
        ),
      ),
    );
  }

  String _bodyString() {
    return handle<void, String>(widget.response, (res) {
      return "チェックイン/アウトを正常に処理しました";
    }, (p0, p1) {
      return "チェックイン/アウトの処理に失敗しました,$p1";
    });
  }
}
