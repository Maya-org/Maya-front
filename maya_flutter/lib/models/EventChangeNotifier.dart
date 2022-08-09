import 'package:flutter/widgets.dart';
import 'package:maya_flutter/ui/APIResponseHandler.dart';

import '../api/API.dart';
import '../api/APIResponse.dart';
import '../api/models/Models.dart';

class EventChangeNotifier extends ChangeNotifier {
  List<ReservableEvent>? _events;

  EventChangeNotifier() {
    updateEvents();
  }

  Future<void> updateEvents() async {
    APIResponse<List<ReservableEvent>?> data = await event();
    handle<List<ReservableEvent>, void>(data, (p0) {
      _events = p0;
      notifyListeners();
    }, (p0, p1) {
      // Failed to get events.
    });
  }

  List<ReservableEvent>? get events => _events;
}
