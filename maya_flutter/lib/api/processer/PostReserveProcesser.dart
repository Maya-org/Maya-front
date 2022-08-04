import 'package:maya_flutter/api/APIResponse.dart';
import 'package:tuple/tuple.dart';

class PostReserveProcessor extends APIResponseProcesser<String> {
  const PostReserveProcessor();

  @override
  bool isKeyMatch(String key) => key == "post-reservation";

  @override
  Tuple2<String?,String> process(json) {
    json as Map<String, dynamic>;
    return Tuple2(json["reservation_id"] as String?, "予約に成功しました");
  }
}
