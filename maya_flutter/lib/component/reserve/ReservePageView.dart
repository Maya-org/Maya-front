import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:maya_flutter/api/models/Models.dart';
import 'package:maya_flutter/component/reserve/ReserveProcessingPageView.dart';
import 'package:maya_flutter/component/ticket/AllTicketTypeSelector.dart';
import 'package:maya_flutter/pages/reserve/TwoFactorPage.dart';

import '../../api/API.dart';
import '../../api/APIResponse.dart';

class ReservePageView extends StatefulWidget {
  final ReservableEvent event;

  const ReservePageView({Key? key, required this.event}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ReservePageViewState();
}

class _ReservePageViewState extends State<ReservePageView> {
  @override
  Widget build(BuildContext context) {
    return AllTicketTypeSelector(
        ticketTypes: widget.event.reservable_ticket_type,
        onSubmit: (BuildContext context, List<TicketType> tickets) {
          _reserveEvent(context, tickets);
        });
  }

  void _reserveEvent(BuildContext context, List<TicketType> ticketTypes) {
    if (widget.event.require_two_factor) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) {
        return TwoFactorPage(builder: (String code) {
          ReserveRequest request = ReserveRequest(
              event_id: widget.event.event_id, tickets: ticketTypes, two_factor_key: code);
          return MaterialPageRoute(builder: (BuildContext context) {
            return ReserveProcessingPageView(
                future: postReserve(request), req: request, event: widget.event);
          });
        });
      }));
    }else{
      ReserveRequest request = ReserveRequest(
          event_id: widget.event.event_id, tickets: ticketTypes);
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) {
        return ReserveProcessingPageView(
            future: postReserve(request), req: request, event: widget.event);
      }));
    }
  }

  Future<APIResponse<String?>> _postReservation(ReserveRequest req) {
    return postReserve(req);
  }
}
