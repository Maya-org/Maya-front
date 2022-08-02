import 'package:flutter/material.dart';
import 'package:maya_flutter/ui/card/UICard.dart';

import '../api/models/Models.dart';
import '../ui/StyledText.dart';

class EventView extends StatelessWidget {
  final ReservableEvent event;

  const EventView({Key? key, required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(event.display_name),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
            padding: const EdgeInsets.all(10),
            child: UICard(
              toExpandTop: false,
              top: Image.network(
                  "https://www.google.com/images/branding/googlelogo/1x/googlelogo_color_272x92dp.png"),
              title: Text(event.display_name),
              body: StyledTextWidget.mdFromString("""説明文:${event.description}
              \\\n開始日時:${event.date_start.toDateTime().toString()}
              \\\n予約済み人数:${event.taken_capacity}/${event.capacity}
              """, true),
            )),
      ),
    );
  }
}
