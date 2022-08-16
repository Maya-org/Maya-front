import 'package:tuple/tuple.dart';

import '../APIResponse.dart';

class CheckProcessor extends APIResponseProcessor<bool>{
  const CheckProcessor();
  @override
  bool isKeyMatch(String key) => key == "check";

  @override
  Tuple2<bool, String> process(json) {
    json as Map<String, dynamic>;
    return const Tuple2(true, "チェックイン/チェックアウトに成功しました");
  }
}