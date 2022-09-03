import 'package:maya_flutter/api/APIResponse.dart';
import 'package:tuple/tuple.dart';

class PostPermissionsProcessor extends APIResponseProcessor<bool>{
  @override
  bool isKeyMatch(String key) => key == "post-permissions";

  @override
  Tuple2<bool?, String> process(json) {
    return const Tuple2(true, "変更に成功しました");
  }
}