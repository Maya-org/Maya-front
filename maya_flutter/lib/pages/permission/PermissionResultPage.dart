import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../api/APIResponse.dart';
import '../../ui/APIResponseHandler.dart';
import '../../ui/DefaultAppBar.dart';

class PermissionResultPage extends StatefulWidget {
  final APIResponse<bool?> response;

  const PermissionResultPage({Key? key, required this.response}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PermissionResultPageState();
}

class _PermissionResultPageState extends State<PermissionResultPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: defaultAppBar("権限付与結果"),
      body: handle(widget.response, (bool data) {
        if (data) {
          return const Center(child: Text("Granted"));
        } else {
          return const Center(child: Text("Denied"));
        }
      }, (response, displayString) {
        return Center(child: Text(displayString));
      }),
    );
  }
}
