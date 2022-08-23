import 'package:flutter/material.dart';
import 'package:maya_flutter/ui/card/EventCard.dart';
import 'package:provider/provider.dart';

import '../../api/models/Models.dart';
import '../../models/EventChangeNotifier.dart';

class EventsView extends StatefulWidget {
  const EventsView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _EventsViewState();
}

class _EventsViewState extends State<EventsView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text("イベント一覧"),
        Flexible(
          child: Consumer<EventChangeNotifier>(
            builder: (context, model, _) {
              List<ReservableEvent>? events = model.events;
              if (events == null) {
                return const Center(
                    child: SizedBox(height: 50, width: 50, child: CircularProgressIndicator()));
              } else {
                return ListView.builder(
                  itemCount: events.length,
                  itemBuilder: (context, index) {
                    return EventCard(events[index]);
                  },
                  shrinkWrap: true,
                  physics: const AlwaysScrollableScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                );
              }
            },
          ),
        ),
      ],
    );
  }
}
