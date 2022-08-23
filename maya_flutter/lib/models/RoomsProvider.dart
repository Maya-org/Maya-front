import 'package:flutter/foundation.dart';
import 'package:maya_flutter/api/API.dart';

import '../api/APIResponse.dart';
import '../api/models/Models.dart';
import '../ui/APIResponseHandler.dart';

class RoomsProvider extends ChangeNotifier{
  List<Room>? _list;
  RoomsProvider(){
    update();
  }

  Future<void> update() async {
    APIResponse<List<Room>?> data = await rooms();
    handle<List<Room>, void>(data, (p0) {
      _list = p0;
      notifyListeners();
    }, (p0, p1) {
      // Failed to get rooms.
    });
  }

  List<Room>? get list => _list;
}