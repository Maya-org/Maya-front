import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:maya_flutter/api/models/Models.dart';
import 'package:maya_flutter/component/ticket/ReservationTicket.dart';
import 'package:provider/provider.dart';

import '../models/UserChangeNotifier.dart';
import '../ui/DefaultAppBar.dart';
import '../ui/StyledText.dart';

class ReservationView extends StatefulWidget {
  final Reservation reservation;

  const ReservationView(this.reservation, {Key? key}) : super(key: key);

  @override
  State<ReservationView> createState() => _ReservationViewState();
}

class _ReservationViewState extends State<ReservationView> {
  @override
  Widget build(BuildContext context) {
    User? user = Provider.of<UserChangeNotifier>(context, listen: true).user;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: defaultAppBar("${widget.reservation.event.display_name}の予約"),
        body: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
          return ConstrainedBox(
              constraints: BoxConstraints.tightFor(
                  width: constraints.maxWidth, height: constraints.maxHeight),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: ChangeNotifierProvider(
                  create: (context) => TicketScroller(),
                  builder: (ctx, child) {
                    return Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        StyledTextWidget.mdFromString(
                            '''**開始日時: ${widget.reservation.event.date_start.toDateTime().toString()}**
        \\\nイベント名: ${widget.reservation.event.display_name}
        \\\nイベントID: ${widget.reservation.event.event_id}
        \\\n予約ID:${widget.reservation.reservation_id}
        \\\n予約人数:${widget.reservation.headCount()}人
        \\\nチケットタイプ:[${widget.reservation.tickets.map((e) => e.ticket_type.display_ticket_name).join(",")}]
        ''', true),
                        ElevatedButton(
                            onPressed: () {
                              _navigateToModifyPage();
                            },
                            child: const Text("予約内容を変更する")),
                        ElevatedButton(
                            onPressed: () {
                              _navigateToCancelPage();
                            },
                            style: ElevatedButton.styleFrom(primary: Colors.red),
                            child: const Text("予約をキャンセルする")),
                        ElevatedButton(
                            onPressed: () {
                              _allScroll(ctx);
                            },
                            child: const Text("チケットを一斉に表示する")),
                        ReservationTicket(user: user, tickets: widget.reservation.tickets)
                      ],
                    );
                  },
                ),
              ));
        }));
  }

  void _navigateToModifyPage() {
    Navigator.of(context).pushNamed("/modify", arguments: widget.reservation);
  }

  void _navigateToCancelPage() {
    Navigator.of(context).pushNamed("/cancel", arguments: widget.reservation);
  }

  void _allScroll(BuildContext ctx) {
    Provider.of<TicketScroller>(ctx,listen: false).scroll();
  }
}

class TicketScroller extends ChangeNotifier {
  DateTime scrollDate = DateTime.now();

  void scroll() {
    scrollDate = DateTime.now();
    notifyListeners();
  }

  bool get isScroll {
    return DateTime.now().difference(scrollDate).inMilliseconds < 100;
  }
}
