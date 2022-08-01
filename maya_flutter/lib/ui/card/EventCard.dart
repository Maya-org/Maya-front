import 'package:flutter/widgets.dart';
import 'package:maya_flutter/api/models/Models.dart';
import 'package:maya_flutter/ui/StyledText.dart';
import 'package:maya_flutter/ui/UI.dart';
import 'package:maya_flutter/ui/card/UICard.dart';

class EventCard extends StatelessWidget {
  final ReservableEvent event;

  const EventCard(this.event, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250,
      child: UICard(
        title: Text(event.display_name),
        body: StyledTextWidget.fromString([
          "説明文:${event.description}",
          "開始日時:${event.date_start.toDateTime().toString()}",
          "予約済み人数:${event.taken_capacity}/${event.capacity}"
        ]),
        onTap: () {
          // TODO 予約ページに遷移
          showOKDialog(context,
              title: Text("イベント#${event.event_id}"),
              body: StyledTextWidget.mdFromString(event.toString(), true));
        },
      ),
    );
  }
}
