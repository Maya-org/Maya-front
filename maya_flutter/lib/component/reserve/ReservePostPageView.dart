import 'package:flutter/material.dart';
import 'package:maya_flutter/api/models/Models.dart';

class ReservePostPageView extends StatefulWidget {
  final ReserveRequest reserveReq;
  final ReservableEvent event;
  final bool isReserved;
  final String? displayString;

  const ReservePostPageView(
      {Key? key, required this.reserveReq, required this.isReserved, required this.event, this.displayString})
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
        child: Text(_genBody()),
      ),
    );
  }

  String _genBody() {
    if (widget.isReserved) {
      return """${widget.event.display_name}の予約が完了しました
開始時刻: ${widget.event.date_start.toDateTime().toString()}
人数:
大人:${widget.reserveReq.group.getGuestCount(GuestType.Adult)}人
子供:${widget.reserveReq.group.getGuestCount(GuestType.Child)}人
保護者:${widget.reserveReq.group.getGuestCount(GuestType.Parent)}人
生徒:${widget.reserveReq.group.getGuestCount(GuestType.Student)}人
""";
    } else {
      return """予約に失敗しました
エラー内容:
${widget.displayString}""";
    }
  }
}
