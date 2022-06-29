import 'package:flutter/widgets.dart';
import 'package:http/http.dart';

import '../api/APIResponse.dart';
import 'StyledText.dart';
import 'UI.dart';

void handle<T>(BuildContext context, APIResponse<T> response, Function(T) onSuccess,
    {Function()? onError}) {
  response.when<Object?>(error: (dynamic dummy, Response res, String displayMessage) {
    if (onError != null) {
      onError();
    } else {
      // To Show Error Dialog
      showOKDialog(context, title: Text(displayMessage),body: StyledTextWidget(Text(res.body)));
    }
    return true;
  }, success: (dynamic t, String displayMessage) {
    t as T;
    onSuccess(t);
    return true;
  });
}
