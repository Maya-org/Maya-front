import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';

class HeatMapChangeNotifier extends ChangeNotifier {
  StreamSubscription<DatabaseEvent>? _subscription;
  Map<String, int> _guestCountData = {};
  Map<String, int> _guestCountSumData = {};

  HeatMapChangeNotifier() {
    FirebaseDatabase.instance.ref("/guestCount").get().then((value) {
      _updateCount_(value);
      _subscription = FirebaseDatabase.instance
          .ref("/guestCount")
          .onChildChanged
          .listen(_updateCount);
    });

    FirebaseDatabase.instance.ref("/guestCountSum").get().then((value) {
      _updateSum_(value);
      _subscription = FirebaseDatabase.instance
          .ref("/guestCountSum")
          .onChildChanged
          .listen(_updateSum);
    });
  }

  void _updateCount(DatabaseEvent event) {
    if (event.snapshot.value is int) {
      _guestCountData[event.snapshot.key!] = event.snapshot.value as int;
      notifyListeners();
    }
  }

  void _updateSum(DatabaseEvent event){
    if (event.snapshot.value is int) {
      _guestCountSumData[event.snapshot.key!] = event.snapshot.value as int;
      notifyListeners();
    }
  }

  void _updateCount_(DataSnapshot snapshot) {
    if (snapshot.value != null) {
      _guestCountData = Map<String, int>.from(snapshot.value as Map<dynamic, dynamic>);
      notifyListeners();
    }
  }

  void _updateSum_(DataSnapshot snapshot) {
    if (snapshot.value != null) {
      _guestCountSumData = Map<String, int>.from(snapshot.value as Map<dynamic, dynamic>);
      notifyListeners();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _subscription?.cancel();
  }

  Map<String, int> get guestCount => _guestCountData;

  Map<String, int> get guestCountSum => _guestCountSumData;
}
