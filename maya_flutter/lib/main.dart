import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:maya_flutter/firebase_options.dart';
import 'package:maya_flutter/messages.i18n.dart';
import 'package:maya_flutter/models/EventChangeNotifier.dart';
import 'package:maya_flutter/models/ReservationChangeNotifier.dart';
import 'package:maya_flutter/models/RoomsProvider.dart';
import 'package:maya_flutter/models/UserChangeNotifier.dart';
import 'package:maya_flutter/pages/EventPage.dart';
import 'package:maya_flutter/pages/LoadingPage.dart';
import 'package:maya_flutter/pages/MainPage.dart';
import 'package:maya_flutter/pages/ReservationPage.dart';
import 'package:maya_flutter/pages/register/SignUp.dart';
import 'package:maya_flutter/pages/register/verifier.dart';
import 'package:maya_flutter/pages/reserve/CancelPage.dart';
import 'package:maya_flutter/pages/reserve/ModifyPage.dart';
import 'package:maya_flutter/pages/reserve/ReservePage.dart';
import 'package:maya_flutter/pages/reserve/ReservePostPage.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/HeatMapChangeNotifier.dart';
import 'models/PermissionsChangeNotifier.dart';

const String prefAuthedKey = "maya-logged-in";
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final prefs = await SharedPreferences.getInstance();
  bool isAuthed = prefs.getBool(prefAuthedKey) ?? false;
  runApp(MayaApp(isInitialAuthed: isAuthed, prefs: prefs));
}

class MayaApp extends StatelessWidget {
  final bool isInitialAuthed;
  final SharedPreferences prefs;

  const MayaApp({Key? key, required this.isInitialAuthed, required this.prefs}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => HeatMapChangeNotifier()),
          ChangeNotifierProvider(create: (_) => PermissionsChangeNotifier()),
          ChangeNotifierProvider(create: (_) => RoomsProvider()),
          ChangeNotifierProvider(create: (_) => UserChangeNotifier(prefs: prefs)),
          ChangeNotifierProvider(create: (_) => EventChangeNotifier()),
          ChangeNotifierProvider(create: (_) => ReservationChangeNotifier()),
        ],
        child: MaterialApp(
          title: const Messages().app_title,
          theme:
              ThemeData(primarySwatch: Colors.blue, textTheme: Theme.of(context).textTheme.apply()),
          home: isInitialAuthed ? const LoadingPage() : SignUpPage(title: const Messages().page_title),
          routes: {
            "/signup": (context) => SignUpPage(title: const Messages().page_title),
            "/loading":(context) => const LoadingPage(),
            "/main": (context) => const MainPage(),
            "/register/phoneVerifier": (context) => const PhoneVerifier(),
            "/reservation": (context) => const ReservationPage(),
            "/reserve": (context) => const ReservePage(),
            "/reserve/post": (context) => const ReservePostPage(),
            "/event": (context) => const EventPage(),
            "/modify": (context) => const ModifyPage(),
            "/cancel": (context) => const CancelPage(),
          },
          debugShowCheckedModeBanner: false,
        ));
  }

  String _initialRoute() {
    if (isInitialAuthed) {
      return '/loading';
    } else {
      return '/';
    }
  }
}
