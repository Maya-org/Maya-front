import 'package:flutter/material.dart';
import 'package:maya_flutter/models/ReservationChangeNotifier.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

import '../../api/APIResponse.dart';
import '../../api/models/Models.dart';
import '../../ui/APIResponseHandler.dart';

class ReserveProcessingPageView extends StatefulWidget {
  final Future<APIResponse<String?>> future;
  final ReserveRequest req;
  final ReservableEvent event;

  const ReserveProcessingPageView(
      {Key? key, required this.future, required this.req, required this.event})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _ReserveProcessingPageViewState();
}

class _ReserveProcessingPageViewState extends State<ReserveProcessingPageView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("予約処理中"),
      ),
      body: Center(
        child: Column(
          children: const [
            Text("只今予約を処理中です..."),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    widget.future.then((response) {
      // 応答があったので、ページを移動する
      _handlePostReservation(
        response,
        widget.req,
        widget.event,
      );
    });
  }

  void _handlePostReservation(dynamic r, ReserveRequest req, ReservableEvent event) {
    r as APIResponse<String?>;
    handle<String, void>(r, (str) {
      // Success
      Provider.of<ReservationChangeNotifier>(context, listen: false).update(); // 予約データを更新
      Navigator.of(context).pushNamedAndRemoveUntil("/reserve/post", ModalRoute.withName("/main"),
          arguments:
              Tuple4<ReserveRequest, ReservableEvent, bool, String?>(req, event, true, null));
    }, (response, displayString) {
      // Failed to reserve
      Navigator.of(context).pushNamedAndRemoveUntil("/reserve/post", ModalRoute.withName("/main"),
          arguments: Tuple4<ReserveRequest, ReservableEvent, bool, String?>(
              req, event, false, displayString));
    });
  }
}
