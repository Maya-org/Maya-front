import 'package:tuple/tuple.dart';

import '../APIResponse.dart';

class PermissionsProcessor extends APIResponseProcesser<List<String>> {
  const PermissionsProcessor();

  @override
  bool isKeyMatch(String key) => key == "permissions";

  @override
  Tuple2<List<String>?, String> process(json) {
    json as Map<String, dynamic>;
    if (json["permissions"] is List<dynamic>) {
      List<String> permissions = (json["permissions"] as List<dynamic>).map((e) => e.toString()).toList();
      return Tuple2(permissions, "権限の取得に成功しました");
    } else {
      return const Tuple2(null, "権限を取得できませんでした(設定されていないユーザーの可能性があります)");
    }
  }
}
