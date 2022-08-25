import 'package:flutter/material.dart';
import 'package:maya_flutter/pages/check/CheckPage.dart';
import 'package:maya_flutter/ui/APIResponseHandler.dart';
import 'package:maya_flutter/ui/DefaultAppBar.dart';

import '../../api/APIResponse.dart';
import '../../api/models/Models.dart';
import '../../pages/MainPage.dart';

class CheckPostPage extends StatefulWidget {
  final APIResponse<bool?> response;
  final Room room;
  final Operation operation;

  const CheckPostPage(
      {Key? key, required this.response, required this.room, required this.operation})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _CheckPostPageState();
}

class _CheckPostPageState extends State<CheckPostPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: defaultAppBar('チェックイン/チェックアウト結果'),
      body: Center(
        child: Column(
          children: [
            Text(_bodyString()),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context)
                    .pushReplacement(MaterialPageRoute(builder: (context) => MainPage()));
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        CheckPage(selectedRoom: widget.room, operation: widget.operation)));
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
