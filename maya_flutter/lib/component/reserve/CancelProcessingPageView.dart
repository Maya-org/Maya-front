import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:maya_flutter/api/APIResponse.dart';
import 'package:maya_flutter/models/ReservationChangeNotifier.dart';
import 'package:provider/provider.dart';

import '../../api/models/Models.dart';
import '../../ui/APIResponseHandler.dart';
import 'CancelPostPageView.dart';

class CancelProcessingPageView extends StatefulWidget {
  final Reservation reservation;
  final Future<APIResponse<bool?>> future;

  const CancelProcessingPageView({Key? key, required this.reservation, required this.future})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _CancelProcessingPageViewState();
}

class _CancelProcessingPageViewState extends State<CancelProcessingPageView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("予約キャンセル処理中"),
      ),
      body: Text("${widget.reservation.event.display_name}の予約をキャンセルしています"),
    );
  }

  @override
  void initState() {
    super.initState();
    widget.future.then((response) {
      // 応答があったので、ページを移動する
      _handlePostCancel(response);
    });
  }

  void _handlePostCancel(dynamic r) {
    r as APIResponse<bool?>;
    handle<bool, void>(r, (res) {
      // 変更に成功
      // Update the reservation list
      Provider.of<ReservationChangeNotifier>(context, listen: false).update();
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) {
        return CancelPostPageView(
          isCancelled: res,
          cancelledReservation: widget.reservation,
          displayMessage: null,
        );
      }),ModalRoute.withName("/main"));
    }, (response, displayString) {
      // 変更に失敗
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) {
        return CancelPostPageView(
          isCancelled: false,
          cancelledReservation: widget.reservation,
          displayMessage: displayString,
        );
      }), ModalRoute.withName("/main"));
    });
  }
}
