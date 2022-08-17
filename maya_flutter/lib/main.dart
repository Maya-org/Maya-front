import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:maya_flutter/firebase_options.dart';
import 'package:maya_flutter/messages.i18n.dart';
import 'package:maya_flutter/models/EventChangeNotifier.dart';
import 'package:maya_flutter/models/ReservationChangeNotifier.dart';
import 'package:maya_flutter/models/RoomsProvider.dart';
import 'package:maya_flutter/models/UserChangeNotifier.dart';
import 'package:maya_flutter/pages/EventPage.dart';
import 'package:maya_flutter/pages/MainPage.dart';
import 'package:maya_flutter/pages/ReservationPage.dart';
import 'package:maya_flutter/pages/register/Register.dart';
import 'package:maya_flutter/pages/register/SignUp.dart';
import 'package:maya_flutter/pages/register/verifyer.dart';
import 'package:maya_flutter/pages/reserve/CancelPage.dart';
import 'package:maya_flutter/pages/reserve/ModifyPage.dart';
import 'package:maya_flutter/pages/reserve/ReservePage.dart';
import 'package:maya_flutter/pages/reserve/ReservePostPage.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(MayaApp(isInitialAuthed: FirebaseAuth.instance.currentUser != null));
}

class MayaApp extends StatelessWidget {
  final bool isInitialAuthed;

  const MayaApp({Key? key, required this.isInitialAuthed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RoomsProvider>(
      create: (_) => RoomsProvider(),
      child: ChangeNotifierProvider<UserChangeNotifier>(
        // TODO 最初2回描画されちゃうけど仕方ない...か?
        create: (_) => UserChangeNotifier(),
        child: ChangeNotifierProvider<EventChangeNotifier>(
          create: (_) => EventChangeNotifier(),
          child: ChangeNotifierProvider<ReservationChangeNotifier>(
            create: (_) => ReservationChangeNotifier(),
            child: MaterialApp(
              title: const Messages().app_title,
              theme: ThemeData(
                  primarySwatch: Colors.blue, textTheme: Theme.of(context).textTheme.apply()),
              initialRoute: _initialRoute(),
              routes: {
                "/": (context) => SignUpPage(title: const Messages().page_title),
                "/main": (context) => const MainPage(),
                "/register/phoneVerifier": (context) => const PhoneVerifier(),
                "/register/nameRegister": (context) => const Register(),
                "/reservation": (context) => const ReservationPage(),
                "/reserve": (context) => const ReservePage(),
                "/reserve/post": (context) => const ReservePostPage(),
                "/event": (context) => const EventPage(),
                "/modify": (context) => const ModifyPage(),
                "/cancel": (context) => const CancelPage(),
              },
              debugShowCheckedModeBanner: false,
            ),
          ),
        ),
      ),
    );
  }

  String _initialRoute() {
    if (isInitialAuthed) {
      return '/main';
    } else {
      return '/';
    }
  }
}
