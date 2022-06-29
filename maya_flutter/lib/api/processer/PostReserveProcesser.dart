import 'package:maya_flutter/api/APIResponse.dart';
import 'package:tuple/tuple.dart';

class PostReserveProcesser extends APIResponseProcesser<bool> {
  const PostReserveProcesser();

  @override
  bool isKeyMatch(String key) => key == "post-reservation";

  @override
  Tuple2<bool?,String> process(json) {
    json as Map<String, dynamic>;
    return const Tuple2(true, "予約に成功しました");
  }
}
