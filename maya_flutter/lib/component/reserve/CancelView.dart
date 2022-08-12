import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:maya_flutter/api/API.dart';

import '../../api/models/Models.dart';
import 'CancelProcessingPageView.dart';

class CancelPageView extends StatefulWidget {
  final Reservation reservation;

  const CancelPageView({Key? key, required this.reservation}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CancelPageViewState();
}

class _CancelPageViewState extends State<CancelPageView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("予約キャンセル画面"),
      ),
      body: Center(
        child: Column(
          children: [
            Text("${widget.reservation.event.display_name}をキャンセルしますか？"),
            ElevatedButton(
              onPressed: () {
                _cancel();
              },
              style: ElevatedButton.styleFrom(primary: Colors.red),
              child: const Text("キャンセル"),
            ),
          ],
        ),
      ),
    );
  }

  void _cancel() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
      return CancelProcessingPageView(
        reservation: widget.reservation,
        future: cancelReserve(widget.reservation),
      );
    }));
  }
}
