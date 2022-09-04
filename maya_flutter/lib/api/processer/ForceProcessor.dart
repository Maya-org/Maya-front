import 'package:maya_flutter/api/APIResponse.dart';
import 'package:maya_flutter/api/models/Models.dart';
import 'package:tuple/tuple.dart';

class ForceProcessor extends APIResponseProcessor<List<Ticket>> {
  @override
  bool isKeyMatch(String key) => key == "force";

  @override
  Tuple2<List<Ticket>?, String> process(json) {
    json as Map<String, dynamic>;
    print('force: $json');
    dynamic tickets = json["tickets"];
    if (tickets is List) {
      return Tuple2(List<Ticket>.from(tickets.map((e) => Ticket.fromJson(e))), "");
    } else {
      return const Tuple2(null, "正常に処理できませんでした");
    }
  }
}
