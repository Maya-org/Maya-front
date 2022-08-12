import 'package:maya_flutter/api/APIResponse.dart';
import 'package:tuple/tuple.dart';

class CancelProcessor extends APIResponseProcessor<bool> {
  const CancelProcessor();


  @override
  bool isKeyMatch(String key) => key == "cancel";

  @override
  Tuple2<bool?, String> process(json) {
    json as Map<String, dynamic>;
    return const Tuple2(true, "キャンセルに成功しました");
  }
}
