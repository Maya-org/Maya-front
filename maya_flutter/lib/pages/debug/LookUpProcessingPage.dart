import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:maya_flutter/pages/MainPage.dart';

import '../../api/APIResponse.dart';
import '../../api/models/Models.dart';
import '../../ui/DefaultAppBar.dart';
import 'LookUpPostPage.dart';


class LookUpProcessingPage extends StatefulWidget {
  final Future<APIResponse<LookUpData?>> future;

  const LookUpProcessingPage({super.key, required this.future});

  @override
  State<StatefulWidget> createState() => _LookUpProcessingPageState();
}

class _LookUpProcessingPageState extends State<LookUpProcessingPage> {
  @override
  void initState() {
    super.initState();
    widget.future.then((APIResponse<LookUpData?> response) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (BuildContext context) => const MainPage()));
      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => LookUpPostPage(response: response)));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: defaultAppBar("情報照会中ページ"),
      body: const Center(
        child: Text("情報を照会中です..."),
      ),
    );
  }
}