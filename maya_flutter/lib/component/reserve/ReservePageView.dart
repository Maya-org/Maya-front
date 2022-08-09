import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:maya_flutter/api/models/Models.dart';
import 'package:tuple/tuple.dart';

import '../../api/API.dart';
import '../../api/APIResponse.dart';
import 'HeadCountPage.dart';

class ReservePageView extends StatefulWidget {
  final ReservableEvent event;

  const ReservePageView({Key? key, required this.event}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ReservePageViewState();
}

class _ReservePageViewState extends State<ReservePageView> {
  @override
  Widget build(BuildContext context) {
    return HeadCountPage(
      title: "イベント: ${widget.event.display_name}の予約ページ",
      onSubmit: (BuildContext ctx, int adult, int child, int parent, int student) {
        _reserveEvent(widget.event, adult, child, parent, student, ctx);
      },
    );
  }

  void _reserveEvent(
      ReservableEvent event, int adult, int child, int parent, int student, BuildContext context) {
    ReserveRequest req = ReserveRequest.fromEvent(
        event,
        Group.fromMap({
          GuestType.Adult: adult,
          GuestType.Child: child,
          GuestType.Parent: parent,
          GuestType.Student: student,
        }));

    Future<APIResponse<String?>> future = _postReservation(req);
    Navigator.of(context).pushReplacementNamed("/reserve/processing",
        arguments: Tuple3<Future<APIResponse<String?>>, ReserveRequest, ReservableEvent>(
            future, req, event));
  }

  Future<APIResponse<String?>> _postReservation(ReserveRequest req) {
    return postReserve(req);
  }
}
