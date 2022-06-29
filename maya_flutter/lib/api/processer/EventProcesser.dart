import 'package:maya_flutter/api/APIResponse.dart';
import 'package:maya_flutter/api/models/Models.dart';
import 'package:tuple/tuple.dart';

class EventProcesser extends APIResponseProcesser<List<ReservableEvent>> {
  const EventProcesser();

  @override
  bool isKeyMatch(String key) => key == "events";

  @override
  Tuple2<List<ReservableEvent>?, String> process(json) {
    json as Map<String, dynamic>;
    Map<String, dynamic> jsonMap = json;
    List<ReservableEvent>? events =
    (jsonMap["events"] as List<dynamic>).map((e) => ReservableEvent.fromJson(e)).toList();

    if (events == null) {
      return const Tuple2(null, "イベントの取得に失敗しました");
    }

    return Tuple2(events, "イベントの取得に成功しました");
  }
}
