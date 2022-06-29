import 'package:maya_flutter/api/models/Models.dart';
import 'package:tuple/tuple.dart';

import '../APIResponse.dart';

class UserProcesser extends APIResponseProcesser<MayaUser> {
  const UserProcesser();

  @override
  bool isKeyMatch(String key) => key == "user";

  @override
  Tuple2<MayaUser?, String> process(json) {
    json as Map<String, dynamic>;
    MayaUser user = MayaUser.fromJson(json);
    return Tuple2(user, "ユーザーの取得に成功しました");
  }
}
