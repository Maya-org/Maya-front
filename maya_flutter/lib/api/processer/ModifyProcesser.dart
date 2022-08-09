import 'package:maya_flutter/api/APIResponse.dart';
import 'package:tuple/tuple.dart';

class ModifyProcessor extends APIResponseProcesser<bool> {
  const ModifyProcessor();
  @override
  bool isKeyMatch(String key) => key == "modify";

  @override
  Tuple2<bool?, String> process(json) {
    json as Map<String, dynamic>;
    return const Tuple2(true, "変更に成功しました");
  }
}
