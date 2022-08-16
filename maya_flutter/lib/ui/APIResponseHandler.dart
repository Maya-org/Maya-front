import 'package:flutter/widgets.dart';
import 'package:http/http.dart';

import '../api/APIResponse.dart';
import 'StyledText.dart';
import 'UI.dart';

R handle<T, R>(
    APIResponse<T?> response, R Function(T) onSuccess, R Function(Response, String) onError) {
  return response.when<R>(error: (dynamic dummy, Response res, String displayMessage) {
    return onError(res, displayMessage);
  }, success: (dynamic t, String displayMessage) {
    t as T;
    return onSuccess(t);
  });
}

void handleVoid<T>(BuildContext context, APIResponse<T> response, void Function(T) onSuccess) {
  return handle<T, void>(
      response,
      onSuccess,
      (res, displayMessage) => {
            showOKDialog(context,
                title: Text(displayMessage), body: StyledTextWidget.fromStringOne(res.body))
          });
}
