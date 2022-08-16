import 'package:flutter/material.dart';
import 'package:maya_flutter/api/API.dart';
import 'package:maya_flutter/component/reserve/TicketTypeSelector.dart';
import 'package:tuple/tuple.dart';

import '../../api/APIResponse.dart';
import '../../api/models/Models.dart';

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
      body: TicketTypeSelector(
        ticketTypes: widget.reservation.event.reservable_ticket_type,
        onSelect: (BuildContext ctx, TicketType type, Group toUpdate) {
          _modify(ctx, type, toUpdate);
        },
      ),
    );
  }

  void _modify(BuildContext context, TicketType type, Group toUpdate) {
    Future<APIResponse<bool?>> future = modifyReserve(widget.reservation, type, toUpdate);
    Navigator.of(context).pushReplacementNamed("/modify/processing",
        arguments: Tuple3<Future<APIResponse<bool?>>, Reservation, Group>(
            future, widget.reservation, toUpdate));
  }
}
