import 'package:flutter/material.dart';

import '../../api/APIResponse.dart';
import 'CheckPostPage.dart';

class CheckProcessingPage extends StatefulWidget{
  final Future<APIResponse<bool?>> future;

  const CheckProcessingPage({Key? key, required this.future}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _CheckProcessingPageState();
}

class _CheckProcessingPageState extends State<CheckProcessingPage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('チェックイン/チェックアウト処理中'),
      ),
      body: const Center(
        child: Text('チェックイン/チェックアウト処理中'),
      ),
    );
  }

  @override
  void initState(){
    super.initState();
    widget.future.then((APIResponse<bool?> response){
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => CheckPostPage(response: response)));
    });
  }
}