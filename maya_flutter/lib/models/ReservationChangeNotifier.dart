import 'package:flutter/widgets.dart';
import 'package:maya_flutter/ui/APIResponseHandler.dart';

import '../api/API.dart';
import '../api/APIResponse.dart';
import '../api/models/Models.dart';

class ReservationChangeNotifier extends ChangeNotifier {
  List<Reservation>? _reservation;

  ReservationChangeNotifier() {
    update();
  }

  Future<void> update() async {
    APIResponse<List<Reservation>?> data = await getReserve();
    handle<List<Reservation>, void>(data, (p0) {
      _reservation = p0;
      notifyListeners();
    }, (p0, p1) {
      // Failed to get reservations.
    });
  }

  List<Reservation>? get reservation => _reservation;
}
