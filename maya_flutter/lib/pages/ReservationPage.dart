import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:maya_flutter/component/ReservationView.dart';

import '../api/models/Models.dart';

class ReservationPage extends StatefulWidget {
  const ReservationPage({Key? key}) : super(key: key);

  @override
  State<ReservationPage> createState() => _ReservationPageState();
}

class _ReservationPageState extends State<ReservationPage> {
  @override
  Widget build(BuildContext context) {
    final reservation = ModalRoute
        .of(context)!
        .settings
        .arguments as Reservation;
    return ReservationView(reservation);
  }
}
