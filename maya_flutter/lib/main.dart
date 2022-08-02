import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:maya_flutter/firebase_options.dart';
import 'package:maya_flutter/messages.i18n.dart';
import 'package:maya_flutter/models/UserChangeNotifier.dart';
import 'package:maya_flutter/pages/EventPage.dart';
import 'package:maya_flutter/pages/MainPage.dart';
import 'package:maya_flutter/pages/Register.dart';
import 'package:maya_flutter/pages/ReservationPage.dart';
import 'package:maya_flutter/pages/SignUp.dart';
import 'package:maya_flutter/pages/debugPage.dart';
import 'package:maya_flutter/pages/verifyer.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MayaApp());
}

class MayaApp extends StatelessWidget {
  const MayaApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<UserChangeNotifier>(
      create: (_) => UserChangeNotifier(),
      child: MaterialApp(
        title: const Messages().app_title,
        theme:
            ThemeData(primarySwatch: Colors.blue, textTheme: Theme.of(context).textTheme.apply()),
        initialRoute: "/",
        routes: {
          "/": (context) => SignUpPage(title: const Messages().page_title),
          "/main": (context) => const MainPage(),
          "/debug": (context) => const DebugPage(),
          "/register/phoneVerifier": (context) => const PhoneVerifier(),
          "/register/nameRegister": (context) => const Register(),
          "/reservation": (context) => const ReservationPage(),
          "/event": (context) => const EventPage(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
