import 'package:flutter/material.dart';
import 'package:maya_flutter/ui/card/UICard.dart';

import '../../api/models/Models.dart';
import 'EventDescriber.dart';

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
                  // top: ImageLoader.loadFromAsset(event.event_id),
                  title: Text(event.display_name),
                  body: EventDescriber(event:event)
                ),
                ElevatedButton(
                  onPressed: () {
                    _reserveEvent(event);
                  },
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 100.0, vertical: 5.0)),
                  child: const Text("このイベントを予約する"),
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
