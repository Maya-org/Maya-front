import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:http/http.dart';
import 'package:tuple/tuple.dart';

import 'API.dart';

part "APIResponse.freezed.dart";

// べつに全然immutableになっていないが、それでもいいかもしれない。
@Freezed(copyWith: false)
class APIResponse<T> with _$APIResponse {
  const factory APIResponse.error(T? dummy, Response res, String displayMessage) = APIResponseError;

  const factory APIResponse.success(T body, String displayMessage) = APIResponseSuccess;
}

abstract class APIResponseProcesser<T> {
  const APIResponseProcesser();

  bool isKeyMatch(String key);

  Tuple2<T?, String> process(dynamic json);
}

APIResponse<T?> processResponse<T>(Response res, APIResponseProcesser<T> processer) {
  switch (res.statusCode) {
    case 200:
      return _processResponse(res, processer);
    case 401:
      return _permissionDenied(res);
    case 400:
      return _internalError(res);
    default:
      return _unknownError(res);
  }
}

APIResponse<T> _processResponse<T>(Response res, APIResponseProcesser processer) {
  dynamic json = safeJsonDecode(res);
  String? key = json["type"];
  if (key == null) {
    return APIResponse.error(null, res, "response type is null");
  } else if (processer.isKeyMatch(key)) {
    try {
      Tuple2<T?, String> result = processer.process(json) as Tuple2<T?, String>;
      if (result.item1 == null) {
        return APIResponse.error(null, res, result.item2);
      } else {
        return APIResponse.success(result.item1 as T, result.item2);
      }
    } catch (e)  {
      return APIResponse.error(null, res,
          "response type is ${key} and processer:${processer.runtimeType} but error: $e");
    }
  }
  return APIResponse.error(
      null, res, "response type is not match to processer[${processer.runtimeType}]");
}

/// when got 401
APIResponse<T?> _permissionDenied<T>(Response res) {
  return APIResponse.error(null, res, "permission denied");
}

/// when got 400
APIResponse<T?> _internalError<T>(Response res) {
  return APIResponse.error(null, res, "InternalError");
}

/// when got other error
APIResponse<T?> _unknownError<T>(Response res) {
  return APIResponse.error(null, res, "unknown error,code:${res.statusCode}");
}
