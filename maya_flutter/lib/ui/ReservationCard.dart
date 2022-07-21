import 'package:flutter/material.dart';
import 'package:maya_flutter/ui/StyledText.dart';
import 'package:maya_flutter/ui/UI.dart';
import 'package:maya_flutter/ui/UICard.dart';

import '../api/models/Models.dart';

class ReservationCard extends StatelessWidget {
  final Reservation reservation;

  const ReservationCard({Key? key, required this.reservation}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return UICard(
      title: Text("${reservation.event.display_name}の予約"),
      body: StyledTextWidget(
        Text('開始日時: ${reservation.event.date_start.toDateTime().toString()}'),
      ),
      onTap: () {
        // TODO 遷移する
        showOKDialog(context,
            title: Text("予約#${reservation.reservation_id}"),
            body: StyledTextWidget(Text(reservation.toString())));
      },
    );
  }
}
