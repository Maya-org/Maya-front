import 'package:flutter/material.dart';
import 'package:maya_flutter/component/EventView.dart';

import '../api/models/Models.dart';

class EventPage extends StatelessWidget {
  const EventPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final event = ModalRoute
        .of(context)!
        .settings
        .arguments as ReservableEvent;
    return EventView(event:event);
  }
}
