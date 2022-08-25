import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../api/models/Models.dart';
import '../../ui/DefaultAppBar.dart';
import '../ReservationPersonCount.dart';

class ModifyPostPageView extends StatefulWidget {
  final bool isReserved;
  final Reservation beforeReservation;
  final List<TicketType> toUpdate;
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
      appBar: defaultAppBar("予約変更完了"),
      body: Center(
        child: _genBody(),
      ),
    );
  }

  Widget _genBody() {
    if (widget.isReserved) {
      return ReservationPersonCount.fromReservation(
        widget.toUpdate,
      );
    } else {
      return Text("""予約変更に失敗しました
エラー内容:
${widget.displayString}""");
    }
  }
}
