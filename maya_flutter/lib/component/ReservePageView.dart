import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:maya_flutter/api/models/Models.dart';
import 'package:tuple/tuple.dart';

import '../api/API.dart';
import '../api/APIResponse.dart';
import '../ui/APIResponseHandler.dart';
import '../ui/UI.dart';

class ReservePageView extends StatefulWidget {
  final ReservableEvent event;

  const ReservePageView({Key? key, required this.event}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ReservePageViewState();
}

class _ReservePageViewState extends State<ReservePageView> {
  final TextEditingController _adult = TextEditingController(text: "0");
  final TextEditingController _child = TextEditingController(text: "0");
  final TextEditingController _parent = TextEditingController(text: "0");
  final TextEditingController _student = TextEditingController(text: "0");

  @override
  Widget build(BuildContext context) {
    ReservableEvent event = widget.event;
    return Container(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextField(
            decoration: const InputDecoration(
              labelText: '予約人数(大人)',
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            controller: _adult,
          ),
          TextField(
            decoration: const InputDecoration(
              labelText: '予約人数(子供)',
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            controller: _child,
          ),
          TextField(
            decoration: const InputDecoration(
              labelText: '予約人数(保護者)',
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            controller: _parent,
          ),
          TextField(
            decoration: const InputDecoration(
              labelText: '予約人数(生徒)',
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            controller: _student,
          ),
          ElevatedButton(
              onPressed: () {
                int adult = int.tryParse(_adult.text) ?? 0;
                int child = int.tryParse(_child.text) ?? 0;
                int parent = int.tryParse(_parent.text) ?? 0;
                int student = int.tryParse(_student.text) ?? 0;
                showOKDialog(context,
                    title: const Text("予約しますか?"), body: Text("""イベント:${event.display_name}
大人:${_adult.text}人
子供:${_child.text}人
保護者:${_parent.text}人
生徒:${_student.text}人"""), onOK: () {
                  _reserveEvent(event, adult, child, parent, student);
                }, toClose: false);
              },
              child: const Text("予約する"))
        ],
      ),
    );
  }

  void _reserveEvent(ReservableEvent event, int adult, int child, int parent, int student) {
    ReserveRequest req = ReserveRequest.fromEvent(
        event,
        Group.fromMap({
          GuestType.Adult: adult,
          GuestType.Child: child,
          GuestType.Parent: parent,
          GuestType.Student: student,
        }));

    _postReservation(req).then((dynamic r) {
      _handlePostReservation(r, req, event);
    });
  }

  Future<APIResponse<String?>> _postReservation(ReserveRequest req) async {
    return await postReserve(req);
  }

  void _handlePostReservation(dynamic r, ReserveRequest req, ReservableEvent event) {
    r as APIResponse<String?>;
    handle<String, void>(r, (str) {
      Navigator.of(context).pushNamed("/reserve/post",
          arguments: Tuple3<ReserveRequest, ReservableEvent, bool>(req, event, true));
    }, (response, displayString) {
      // Failed to reserve
      Navigator.of(context).pushNamed("/reserve/post",
          arguments: Tuple3<ReserveRequest, ReservableEvent, bool>(req, event, false));
    });
  }
}
