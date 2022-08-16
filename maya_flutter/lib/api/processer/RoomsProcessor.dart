import 'package:maya_flutter/api/APIResponse.dart';
import 'package:maya_flutter/api/models/Models.dart';
import 'package:tuple/tuple.dart';

class RoomsProcessor extends APIResponseProcessor<List<Room>> {

  const RoomsProcessor();

  @override
  bool isKeyMatch(String key) => key == 'rooms';

  @override
  Tuple2<List<Room>?, String> process(json) {
    json as Map<String,dynamic>;
    List<Room> rooms = json["rooms"].map<Room>((e) => Room.fromJson(e)).toList();
    return Tuple2(rooms, '部屋一覧の取得に成功しました');
  }
}