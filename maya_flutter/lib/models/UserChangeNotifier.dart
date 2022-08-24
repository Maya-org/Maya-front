import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

class UserChangeNotifier extends ChangeNotifier {
  User? _user;
  final SharedPreferences prefs;

  UserChangeNotifier({required this.prefs}) {
    // TODO authStateChangesで監視してるが、多分いつかこれを変えるときが来る
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      _user = user;
      if(user != null && user.phoneNumber != null){
        print('marked as verified');
        prefs.setBool(prefAuthedKey, true);
      }else{
        print('marked as not verified');
        prefs.setBool(prefAuthedKey, false);
      }
      notifyListeners();
    });
  }

  User? get user => _user;
}
