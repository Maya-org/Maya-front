import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../api/models/Models.dart';

class ModifyPostPageView extends StatefulWidget {
  final bool isReserved;
  final Reservation beforeReservation;
  final Group toUpdate;
  final String? displayString;

  const ModifyPostPageView(
      {Key? key,
      required this.isReserved,
      required this.beforeReservation,
      required this.toUpdate,
      this.displayString})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _ModifyPostPageViewState();
}

class _ModifyPostPageViewState extends State<ModifyPostPageView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("予約変更完了"),
      ),
      body: Center(
        child: Text(_genBody()),
      ),
    );
  }

  String _genBody() {
    if (widget.isReserved) {
      return """${widget.beforeReservation.event.display_name}の予約変更が完了しました
開始時刻: ${widget.beforeReservation.event.date_start.toDateTime().toString()}
人数:
大人:${widget.toUpdate.getGuestCount(GuestType.Adult)}人
子供:${widget.toUpdate.getGuestCount(GuestType.Child)}人
保護者:${widget.toUpdate.getGuestCount(GuestType.Parent)}人
生徒:${widget.toUpdate.getGuestCount(GuestType.Student)}人
""";
    } else {
      return """予約変更に失敗しました
エラー内容:
${widget.displayString}""";
    }
  }
}
