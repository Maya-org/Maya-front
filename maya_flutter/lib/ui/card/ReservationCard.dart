import 'package:flutter/material.dart';
import 'package:maya_flutter/ui/card/UICard.dart';

import '../../api/models/Models.dart';
import '../../component/event/EventDescriber.dart';

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
        title: Text("${reservation.event.display_name}の予約"),
        body: EventDescriber(
          event: reservation.event,
          toDescribeMore: false,
        ),
        onTap: () {
          Navigator.of(context).pushNamed('/reservation',arguments: reservation);
        },
      ),
    );
  }
}
