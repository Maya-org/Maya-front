import 'package:flutter/material.dart';
import 'package:maya_flutter/api/API.dart';
import 'package:maya_flutter/component/reserve/ModifyProcessingPageView.dart';
import 'package:maya_flutter/component/ticket/AllTicketTypeSelector.dart';

import '../../api/models/Models.dart';
import '../../pages/reserve/TwoFactorPage.dart';

class ModifyPageView extends StatefulWidget {
  final Reservation reservation;

  const ModifyPageView({Key? key, required this.reservation}) : super(key: key);

  @override
  State<ModifyPageView> createState() => _ModifyPageViewState();
}

class _ModifyPageViewState extends State<ModifyPageView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.reservation.event.display_name}の予約変更画面"),
      ),
      body: AllTicketTypeSelector(
        ticketTypes: widget.reservation.event.reservable_ticket_type,
        onSubmit: (BuildContext context, List<TicketType> tickets) {
          _modifyReservation(context, tickets);
        },
      ),
    );
  }

  void _modifyReservation(BuildContext context, List<TicketType> ticketTypes) {
    if (widget.reservation.event.require_two_factor) {
      // 2FAが必要な場合は2FA画面を表示する
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) {
        return TwoFactorPage(builder: (String code) {
          return MaterialPageRoute(builder: (BuildContext context) {
            return ModifyProcessingPageView(
                future: modifyReserve(ticketTypes, widget.reservation, twoFactorKey: code),
                fromReservation: widget.reservation,
                toUpdate: ticketTypes);
          });
        });
      }));
    } else {
      // 2FAが不要な場合は予約変更を行う
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) {
        return ModifyProcessingPageView(
            future: modifyReserve(ticketTypes, widget.reservation),
            fromReservation: widget.reservation,
            toUpdate: ticketTypes);
      }));
    }
  }
}
