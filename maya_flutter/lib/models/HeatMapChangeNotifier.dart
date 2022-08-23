import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';

class HeatMapChangeNotifier extends ChangeNotifier {
  StreamSubscription<DatabaseEvent>? _subscription;
  Map<String, int> _data = {};

  HeatMapChangeNotifier() {
    FirebaseDatabase.instance.ref("/guestCount").get().then((value) {
      _update_(value);
      _subscription = FirebaseDatabase.instance.ref("/guestCount").onChildChanged.listen(_update);
    });
  }

  void _update(DatabaseEvent event) {
    print('update');
    if (event.snapshot.value is int) {
      _data[event.snapshot.key!] = event.snapshot.value as int;
      notifyListeners();
    }
  }

  void _update_(DataSnapshot snapshot) {
    print('init data');
    if (snapshot.value != null) {
      _data = Map<String, int>.from(snapshot.value as Map<dynamic, dynamic>);
      notifyListeners();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _subscription?.cancel();
  }

  Map<String, int> get data => _data;
}
