import 'package:flutter/material.dart';

import '../../api/models/Models.dart';
import '../../component/ticket/ReservationTicket.dart';
import '../../ui/DefaultAppBar.dart';

class ForcePostPage extends StatelessWidget {
  final List<Ticket>? data;
  final bool isSuccess;
  final String? message;

  const ForcePostPage({Key? key, required this.data, required this.isSuccess, this.message})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: defaultAppBar("強制発券完了"),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isSuccess) const Text("強制発券が完了しました") else const Text("強制発券に失敗しました"),
            if (message != null) Text("メッセージ:${message!}"),
            if (data != null) ReservationTicket(uid: "[force]", tickets: data!),
          ],
        ),
      ),
    );
  }
}
