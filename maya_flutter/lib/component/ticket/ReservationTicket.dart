import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:maya_flutter/ui/StyledText.dart';
import 'package:maya_flutter/ui/card/UICard.dart';

import '../../api/models/Models.dart';
import 'TicketQRCode.dart';

class ReservationTicket extends StatefulWidget {
  final Reservation reservation;
  final User? user;

  const ReservationTicket({super.key, required this.reservation, required this.user});

  @override
  State<ReservationTicket> createState() => _ReservationTicketState();
}

class _ReservationTicketState extends State<ReservationTicket> {
  @override
  Widget build(BuildContext context) {
    return UICard(
      margin: const EdgeInsets.all(10),
      title: Text("${widget.reservation.event.display_name}の予約"),
      body: StyledTextWidget.mdFromString(
          '''**開始日時: ${widget.reservation.event.date_start.toDateTime().toString()}**
        \\\nイベント名: ${widget.reservation.event.display_name}
        \\\nイベントID: ${widget.reservation.event.event_id}
        \\\n予約ID:${widget.reservation.reservation_id}
        \\\n予約人数:${widget.reservation.headCount()}人
        \\\nチケットタイプ:[${widget.reservation.tickets.map((e) => e.ticket_type.display_ticket_name).join(",")}]
        ''', true),
      top: () {
        if (widget.user != null) {
          return Column(
            children: widget.reservation.tickets
                .map((e) => TicketQRCode(user: widget.user!, ticket: e))
                .toList(),
          );
        } else {
          return Container();
        }
      }(),
    );
  }
}
