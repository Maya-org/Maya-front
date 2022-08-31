import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:maya_flutter/ui/DefaultAppBar.dart';

import '../../api/APIResponse.dart';
import 'PermissionResultPage.dart';

class PermissionProgressPage extends StatefulWidget {
  final Future<APIResponse<bool?>> future;

  const PermissionProgressPage({Key? key, required this.future}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PermissionProgressPageState();
}

class _PermissionProgressPageState extends State<PermissionProgressPage> {
  @override
  void initState() {
    super.initState();
    widget.future.then((APIResponse<bool?> response) {
      Navigator.of(context).pushReplacementNamed("/main");
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (ctx) => PermissionResultPage(response: response)));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: defaultAppBar("権限付与中"), body: const Center(child: CircularProgressIndicator()));
  }
}
