import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:maya_flutter/api/models/Models.dart';
import 'package:maya_flutter/component/event/EventDescriber.dart';
import 'package:maya_flutter/component/ticket/ReservationTicket.dart';
import 'package:provider/provider.dart';

import '../models/UserChangeNotifier.dart';
import '../pages/TicketListPage.dart';
import '../ui/DefaultAppBar.dart';

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
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    EventDescriber(event: widget.reservation.event),
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
                        if (user != null) {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (ctx) =>
                                  TicketListPage(user: user, tickets: widget.reservation.tickets)));
                        }
                      },
                      style: ElevatedButton.styleFrom(primary: Colors.green),
                      child: const Text("チケットを一斉に表示する"),
                    ),
                    ReservationTicket(user: user, tickets: widget.reservation.tickets)
                  ],
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
}
