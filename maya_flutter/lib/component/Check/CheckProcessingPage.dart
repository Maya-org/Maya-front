import 'package:flutter/material.dart';

import '../../api/APIResponse.dart';
import '../../api/models/Models.dart';
import '../../ui/DefaultAppBar.dart';
import 'CheckPostPage.dart';

class CheckProcessingPage extends StatefulWidget{
  final Future<APIResponse<bool?>> future;
  final Room room;
  final Operation operation;

  const CheckProcessingPage({Key? key, required this.future, required this.room, required this.operation}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _CheckProcessingPageState();
}

class _CheckProcessingPageState extends State<CheckProcessingPage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: defaultAppBar('チェックイン/チェックアウト処理中'),
      body: const Center(
        child: Text('チェックイン/チェックアウト処理中'),
      ),
    );
  }

  @override
  void initState(){
    super.initState();
    widget.future.then((APIResponse<bool?> response){
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => CheckPostPage(response: response, room: widget.room, operation: widget.operation)));
    });
  }
}