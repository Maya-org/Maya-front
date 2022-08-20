import 'package:maya_flutter/api/APIResponse.dart';
import 'package:tuple/tuple.dart';

class RegisterProcessor extends APIResponseProcessor<bool> {
  const RegisterProcessor();

  @override
  bool isKeyMatch(String key) => key == "register";

  @override
  Tuple2<bool?,String> process(json) {
    json as Map<String, dynamic>;
    bool alreadyRegistered = json["alreadyRegistered"];
    return Tuple2(alreadyRegistered, "登録に成功しました");
  }
}