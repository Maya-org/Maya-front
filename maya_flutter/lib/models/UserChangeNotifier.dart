import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';

class UserChangeNotifier extends ChangeNotifier {
  User? _user;

  UserChangeNotifier() {
    FirebaseAuth.instance.userChanges().listen((User? user) {
      _user = user;
      notifyListeners();
    });
  }

  User? get user => _user;
}
