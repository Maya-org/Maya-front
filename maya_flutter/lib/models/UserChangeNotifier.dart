import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';

class UserChangeNotifier extends ChangeNotifier {
  User? _user;

  UserChangeNotifier() {
    // TODO authStateChangesで監視してるが、多分いつかこれを変えるときが来る
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      _user = user;
      notifyListeners();
    });
  }

  User? get user => _user;
}
