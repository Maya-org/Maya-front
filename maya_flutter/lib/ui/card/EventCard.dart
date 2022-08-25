import 'package:flutter/widgets.dart';
import 'package:maya_flutter/api/models/Models.dart';
import 'package:maya_flutter/ui/card/UICard.dart';

import '../../component/event/EventDescriber.dart';

class EventCard extends StatelessWidget {
  final ReservableEvent event;

  const EventCard(this.event, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250,
      height: 0.0,
      child: UICard(
        toExpandTop: true,
        title: Text(event.display_name),
        body: EventDescriber(event: event),
        onTap: () {
          Navigator.of(context).pushNamed("/event", arguments: event);
        },
      ),
    );
  }
}
