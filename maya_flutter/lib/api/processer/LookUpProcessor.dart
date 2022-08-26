import 'package:maya_flutter/api/APIResponse.dart';
import 'package:tuple/tuple.dart';

import '../models/Models.dart';

class LookUpProcessor extends APIResponseProcessor<LookUpData> {
  @override
  bool isKeyMatch(String key) => key == "lookup";

  @override
  Tuple2<LookUpData?, String> process(json) {
    try {
      print('LookUpProcessor.process: $json');
      LookUpData? data = LookUpData.fromJson(json);
      return Tuple2(data, "");
    } catch (e) {
      return Tuple2(null, e.toString());
    }
  }
}
