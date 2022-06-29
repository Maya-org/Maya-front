import 'package:maya_flutter/api/APIResponse.dart';
import 'package:tuple/tuple.dart';

class RegisterProcesser extends APIResponseProcesser<bool> {
  const RegisterProcesser();

  @override
  bool isKeyMatch(String key) => key == "register";

  @override
  Tuple2<bool?,String> process(json) {
    json as Map<String, dynamic>;
    return const Tuple2(true, "登録に成功しました");
  }
}