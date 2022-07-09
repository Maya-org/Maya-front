import 'package:maya_flutter/api/APIResponse.dart';
import 'package:tuple/tuple.dart';

class PostReserveProcessor extends APIResponseProcesser<bool> {
  const PostReserveProcessor();

  @override
  bool isKeyMatch(String key) => key == "post-reservation";

  @override
  Tuple2<bool?,String> process(json) {
    json as Map<String, dynamic>;
    return const Tuple2(true, "予約に成功しました");
  }
}
