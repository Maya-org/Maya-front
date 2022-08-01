import 'package:flutter/material.dart';
import 'package:maya_flutter/api/models/Models.dart';
import 'package:maya_flutter/ui/card/ReservationCard.dart';

class ReservationView extends StatelessWidget {
  final Reservation reservation;

  const ReservationView(this.reservation, {Key? key}) : super(key: key);

  // TODO QRコード表示
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("${reservation.event.display_name}の予約"),
        ),
        body: ReservationCard(
          reservation: reservation,
        ));
  }
}
