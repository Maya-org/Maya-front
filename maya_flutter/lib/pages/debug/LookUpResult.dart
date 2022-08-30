import 'package:flutter/material.dart';
import 'package:maya_flutter/util/CollectionUtils.dart';

import '../../api/models/Models.dart';

class LookUpResult extends StatelessWidget {
  final LookUpData data;

  const LookUpResult({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = _gen();
    return ListView.builder(
        physics: const NeverScrollableScrollPhysics(), // タッチ処理が持っていかれるので
        itemBuilder: (ctx, index) {
          return widgets[index];
        },
        itemCount: widgets.length,
        shrinkWrap: true);
  }

  List<Widget> _gen() {
    List<Widget> widgets = [];
    widgets.addAll([
      TracksWidget(tracks: data.tracks),
      ReservationWidget(reservation: data.reservation),
    ]);
    return widgets;
  }
}

class TracksWidget extends StatelessWidget {
  final List<RawTrackData?> tracks;

  const TracksWidget({Key? key, required this.tracks}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          child: ExpansionPanelList.radio(
            children: [
              ExpansionPanelRadio(
                value: GlobalKey(),
                headerBuilder: (ctx, isExpanded) => const ListTile(title: Text("入退室記録")),
                body: Column(
                  children:
                      tracks.filterNotNull().map((RawTrackData track) => _gen(track)).toList(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _gen(RawTrackData track) {
    return ListTile(
      title: Text(_genTitle(track.data)),
      subtitle: Text(track.time.toStringWithSec()),
    );
  }

  String _genTitle(TrackData data) {
    if (data.fromRoom != null) {
      return "${data.fromRoom!.display_name}から${data.toRoom.display_name}${data.operation.operationDisplayName}";
    }
    return "${data.toRoom.display_name}${data.operation.operationDisplayName}";
  }
}

class ReservationWidget extends StatelessWidget {
  final Reservation? reservation;

  const ReservationWidget({Key? key, required this.reservation}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text("予約情報"),
        Container(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: _gen(),
          ),
        ),
      ],
    );
  }

  List<Widget> _gen() {
    List<Widget> widgets = [];
    if (reservation != null) {
      widgets.addAll([
        Text("予約ID: ${reservation!.reservation_id}"),
        Text("予約イベント: ${reservation!.event.display_name}"),
        const SizedBox(height: 8),
        ExpansionPanelList.radio(children: [
          ExpansionPanelRadio(
            body: Column(children: _tickets()),
            headerBuilder: (ctx, isExpanded) =>
                ListTile(title: Text("チケット一覧(計${reservation!.tickets.length}枚)")),
            value: GlobalKey(),
          )
        ])
      ]);
    }
    return widgets;
  }

  List<Widget> _tickets() {
    return reservation!.tickets.map((Ticket ticket) {
      return ListTile(
        title: Text("チケットID:${ticket.ticket_id}"),
        subtitle: Text(ticket.ticket_type.display_ticket_name),
      );
    }).toList();
  }
}
