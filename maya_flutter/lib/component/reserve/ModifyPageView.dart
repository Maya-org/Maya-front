import 'package:flutter/material.dart';
import 'package:maya_flutter/api/API.dart';
import 'package:maya_flutter/component/reserve/HeadCountPage.dart';
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
      body: HeadCountPage(
          title: "イベント:${widget.reservation.event.display_name}の予約変更ページ",
          onSubmit: (BuildContext ctx, int adult, int child, int parent, int student) {
            _modify(ctx, adult, child, parent, student);
          },
          init_adult: widget.reservation.group_data.getGuestCount(GuestType.Adult).toString(),
          init_child: widget.reservation.group_data.getGuestCount(GuestType.Child).toString(),
          init_parent: widget.reservation.group_data.getGuestCount(GuestType.Parent).toString(),
          init_student: widget.reservation.group_data.getGuestCount(GuestType.Student).toString()),
    );
  }

  void _modify(BuildContext context, int adult, int child, int parent, int student) {
    Group group = Group.fromMap({
      GuestType.Adult: adult,
      GuestType.Child: child,
      GuestType.Parent: parent,
      GuestType.Student: student,
    });
    Future<APIResponse<bool?>> future = modifyReserve(widget.reservation, group);

    Navigator.of(context).pushReplacementNamed("/modify/processing",
        arguments: Tuple3<Future<APIResponse<bool?>>, Reservation, Group>(
            future, widget.reservation, group));
  }
}
