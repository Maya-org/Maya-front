import 'package:flutter/material.dart';
import 'package:maya_flutter/ui/card/UICard.dart';

import '../api/models/Models.dart';
import '../ui/StyledText.dart';

class EventView extends StatefulWidget {
  final ReservableEvent event;

  const EventView({Key? key, required this.event}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _EventViewState();
}

class _EventViewState extends State<EventView> {
  @override
  Widget build(BuildContext context) {
    ReservableEvent event = widget.event;

    return Scaffold(
      appBar: AppBar(
        title: Text(event.display_name),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
            padding: const EdgeInsets.all(10),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                UICard(
                  toExpandTop: false,
                  top: Image.network(
                      "https://www.google.com/images/branding/googlelogo/1x/googlelogo_color_272x92dp.png"),
                  title: Text(event.display_name),
                  body: StyledTextWidget.mdFromString("""説明文:${event.description}
                    \\\n開始日時:${event.date_start.toDateTime().toString()}
                    \\\n予約済み人数:${event.taken_capacity}/${event.capacity},
                    \\\nイベントID:${event.event_id}
                    \\\nチケットタイプ:${event.reservable_ticket_type.map((ticket) => ticket.toString()).join(", ")}
                    \\\n最大予約数:${event.maximum_reservations_per_user ?? -1}人
                    """, true),
                ),
                Row(
                  children: [
                    Expanded(child: Text("開始日時${event.date_start.toDateTime().toString()}")),
                    Expanded(child: Text("終了日時${event.date_end?.toDateTime().toString()}")),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    _reserveEvent(event);
                  },
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 100.0, vertical: 5.0)),
                  child: const Text("予約する"),
                )
              ]),
            )),
      ),
    );
  }

  void _reserveEvent(ReservableEvent event) {
    Navigator.of(context).pushNamed("/reserve", arguments: event);
  }
}
