import 'package:flutter/material.dart';
import 'package:maya_flutter/api/models/Models.dart';

import '../ReservationPersonCount.dart';

class ReservePostPageView extends StatefulWidget {
  final ReserveRequest reserveReq;
  final ReservableEvent event;
  final bool isReserved;
  final String? displayString;

  const ReservePostPageView(
      {Key? key,
      required this.reserveReq,
      required this.isReserved,
      required this.event,
      this.displayString})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _ReservePostPageViewState();
}

class _ReservePostPageViewState extends State<ReservePostPageView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("予約完了"),
      ),
      body: Center(
        child: _genBody(),
      ),
    );
  }

  Widget _genBody() {
    if (widget.isReserved) {
      return ReservationPersonCount(
        ticketTypes: widget.reserveReq.tickets,
      );
    } else {
      return Text("""予約に失敗しました
エラー内容:
${widget.displayString}""");
    }
  }
}
