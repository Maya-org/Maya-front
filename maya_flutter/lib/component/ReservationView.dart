import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:maya_flutter/api/models/Models.dart';
import 'package:maya_flutter/component/ticket/Ticket.dart';
import 'package:provider/provider.dart';

import '../models/UserChangeNotifier.dart';

class ReservationView extends StatelessWidget {
  final Reservation reservation;

  const ReservationView(this.reservation, {Key? key}) : super(key: key);

  // TODO QRコード表示
  @override
  Widget build(BuildContext context) {
    User? user = Provider.of<UserChangeNotifier>(context, listen: true).user;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("${reservation.event.display_name}の予約"),
        ),
        body: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
          return ConstrainedBox(
              constraints: BoxConstraints.tightFor(width: constraints.maxWidth,height: constraints.maxHeight),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Ticket(user: user, reservation: reservation),
                  const Expanded(child: SizedBox()),
                ],
              ));
        }));
  }
}
