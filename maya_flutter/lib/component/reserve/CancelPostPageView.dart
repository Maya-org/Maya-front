import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../api/models/Models.dart';

class CancelPostPageView extends StatelessWidget {
  final Reservation cancelledReservation;
  final bool isCancelled;
  final String? displayMessage;

  const CancelPostPageView(
      {Key? key,
      required this.cancelledReservation,
      required this.isCancelled,
      required this.displayMessage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("予約キャンセル結果"),
      ),
      body: Text(_bodyString()),
    );
  }

  String _bodyString() {
    if (isCancelled) {
      return "キャンセルに成功しました";
    } else {
      return "キャンセルに失敗しました ($displayMessage)";
    }
  }
}
