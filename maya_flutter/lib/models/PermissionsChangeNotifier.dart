import 'package:flutter/widgets.dart';
import 'package:maya_flutter/api/API.dart';
import 'package:provider/provider.dart';

import '../api/APIResponse.dart';
import '../ui/APIResponseHandler.dart';

class PermissionsChangeNotifier extends ChangeNotifier {
  List<String> _permissions = [];

  PermissionsChangeNotifier() {
    update();
  }

  Future<void> update() async {
    APIResponse<List<String>?> data = await getPermissions();
    handle<List<String>, void>(data, (p0) {
      _permissions = p0;
      notifyListeners();
    }, (p0, p1) {
      // Failed to get permissions.
    });
  }

  List<String> get permissions => _permissions;
}

bool checkPermission(String permission,BuildContext context,{bool listen = true}) {
  return Provider.of<PermissionsChangeNotifier>(context,listen: listen).permissions.contains(permission);
}