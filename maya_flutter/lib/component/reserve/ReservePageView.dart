import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:maya_flutter/api/models/Models.dart';
import 'package:maya_flutter/component/reserve/TicketTypeSelector.dart';
import 'package:maya_flutter/pages/reserve/TwoFactorPage.dart';
import 'package:tuple/tuple.dart';

import '../../api/API.dart';
import '../../api/APIResponse.dart';
import '../../pages/reserve/ReserveProcessingPage.dart';

class ReservePageView extends StatefulWidget {
  final ReservableEvent event;

  const ReservePageView({Key? key, required this.event}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ReservePageViewState();
}

class _ReservePageViewState extends State<ReservePageView> {
  @override
  Widget build(BuildContext context) {
    return TicketTypeSelector(
      ticketTypes: widget.event.reservable_ticket_type,
      onSelect: (BuildContext ctx, TicketType type, Group toUpdate) {
        _reserveEvent(ctx, type, toUpdate);
      },
    );
  }

  void _reserveEvent(BuildContext context, TicketType type, Group toUpdate) {
    if (type.require_two_factor) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) {
        return TwoFactorPage(
          event: widget.event,
          toUpdate: toUpdate,
          type: type,
          builder: (String code) {
            ReserveRequest req = ReserveRequest(
                event_id: widget.event.event_id,
                group: toUpdate,
                ticket_type_id: type.ticket_type_id,
                two_factor_key: code);
            return MaterialPageRoute(
                builder: (BuildContext context) {
                  return const ReserveProcessingPage();
                },
                settings: RouteSettings(
                    arguments:
                        Tuple3<Future<APIResponse<String?>>, ReserveRequest, ReservableEvent>(
                            postReserve(req), req, widget.event)));
          },
        );
      }));
    } else {
      ReserveRequest req = ReserveRequest(
          event_id: widget.event.event_id, group: toUpdate, ticket_type_id: type.ticket_type_id);

      Future<APIResponse<String?>> future = _postReservation(req);
      Navigator.of(context).pushReplacementNamed("/reserve/processing",
          arguments: Tuple3<Future<APIResponse<String?>>, ReserveRequest, ReservableEvent>(
              future, req, widget.event));
    }
  }

  Future<APIResponse<String?>> _postReservation(ReserveRequest req) {
    return postReserve(req);
  }
}
