import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:maya_flutter/api/API.dart';
import 'package:maya_flutter/ui/DefaultAppBar.dart';

import '../../api/APIResponse.dart';
import '../../api/models/Models.dart';
import '../../component/ticket/AllTicketTypeSelector.dart';
import 'ForceProcessingPage.dart';

class ForceTicketSelectPage extends StatefulWidget {
  final String? data;
  final ReservableEvent event;

  const ForceTicketSelectPage({Key? key, this.data, required this.event}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ForceTicketSelectPageState();
}

class _ForceTicketSelectPageState extends State<ForceTicketSelectPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: defaultAppBar("強制発券画面"),
      body: AllTicketTypeSelector(
          ticketTypes: widget.event.reservable_ticket_type,
          onSubmit: (BuildContext context, List<TicketType> tickets) {
            _reserveEvent(context, tickets);
          }),
    );
  }

  void _reserveEvent(BuildContext context, List<TicketType> tickets) {
    ReserveRequest req = ReserveRequest(event_id: widget.event.event_id, tickets: tickets);
    Future<APIResponse<List<Ticket>?>> future = force(req, widget.data);
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) {
      return ForceProcessingPage(future: future, req: req, event: widget.event);
    }));
  }
}
