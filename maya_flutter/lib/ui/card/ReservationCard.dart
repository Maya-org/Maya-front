import 'package:flutter/material.dart';
import 'package:maya_flutter/ui/StyledText.dart';
import 'package:maya_flutter/ui/card/UICard.dart';

import '../../api/models/Models.dart';

class ReservationCard extends StatelessWidget {
  final Reservation reservation;

  const ReservationCard({Key? key, required this.reservation}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250,
      height: 0.0,
      child: UICard(
        toExpandTop: true,
        top: const Icon(Icons.event, color: Colors.blue),
        title: Text("${reservation.event.display_name}の予約"),
        body: StyledTextWidget.mdFromString(
          '開始日時: ${reservation.event.date_start.toDateTime().toString()}',
          true
        ),
        onTap: () {
          Navigator.of(context).pushNamed('/reservation',arguments: reservation);
        },
      ),
    );
  }
}
