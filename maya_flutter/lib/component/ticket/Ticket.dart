import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:maya_flutter/ui/StyledText.dart';
import 'package:maya_flutter/ui/card/UICard.dart';

import '../../api/models/Models.dart';
import 'TicketQRCode.dart';

class Ticket extends StatelessWidget {
  final Reservation reservation;
  final User? user;

  const Ticket({super.key, required this.reservation, required this.user});

  @override
  Widget build(BuildContext context) {
    return UICard(
      margin: const EdgeInsets.all(10),
      title: Text("${reservation.event.display_name}の予約"),
      body: StyledTextWidget.mdFromString(
          '''**開始日時: ${reservation.event.date_start.toDateTime().toString()}**
        \\\nイベント名: ${reservation.event.display_name}
        \\\nイベントID: ${reservation.event.event_id}
        \\\n予約ID:${reservation.reservation_id}
        \\\n予約人数:${reservation.group_data.all_guests.length}人
        \\\nチケットタイプ:${reservation.reserved_ticket_type.display_ticket_name}
        ''', true),
      top: () {
        if (user != null) {
          return TicketQRCode(user: user!, reservation: reservation);
        } else {
          return Container();
        }
      }(),
    );
  }
}
