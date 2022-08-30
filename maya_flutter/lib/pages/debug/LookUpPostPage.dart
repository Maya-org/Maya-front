import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:maya_flutter/ui/APIResponseHandler.dart';

import '../../api/APIResponse.dart';
import '../../api/models/Models.dart';
import '../../ui/DefaultAppBar.dart';
import 'LookUpResult.dart';

class LookUpPostPage extends StatefulWidget {
  final APIResponse<LookUpData?> response;

  const LookUpPostPage({Key? key, required this.response}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LookUpPostPageState();
}

class _LookUpPostPageState extends State<LookUpPostPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: defaultAppBar("情報照会ページ"),
      body: SizedBox.expand(child: SingleChildScrollView(child: Column(children: _body()))),
    );
  }

  List<Widget> _body() {
    List<Widget> list = [const Center(child: Text("情報照会結果"))];
    list.addAll(handle(widget.response, (LookUpData p0) => [LookUpResult(data: p0)],
        (p0, p1) => [const Text("照会に失敗しました"), Text(p1.toString())]));
    return list;
  }
}
