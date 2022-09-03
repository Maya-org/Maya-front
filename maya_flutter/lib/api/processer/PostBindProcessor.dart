import 'package:maya_flutter/api/APIResponse.dart';
import 'package:tuple/tuple.dart';

class PostBindProcessor extends APIResponseProcessor<bool> {
  @override
  bool isKeyMatch(String key) => key == "bind";

  @override
  Tuple2<bool, String> process(json) {
    json as Map<String, dynamic>;
    return const Tuple2(true, "紐づけに成功しました");
  }
}
