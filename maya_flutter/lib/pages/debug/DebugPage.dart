import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:maya_flutter/models/EventChangeNotifier.dart';
import 'package:maya_flutter/models/PermissionsChangeNotifier.dart';
import 'package:maya_flutter/models/ReservationChangeNotifier.dart';
import 'package:maya_flutter/models/UserChangeNotifier.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../ui/DefaultAppBar.dart';

class DebugPage extends StatefulWidget {
  const DebugPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _DebugPageState();
}

class _DebugPageState extends State<DebugPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: defaultAppBar("デバッグページ(V1.1)"),
      body: SizedBox.expand(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              const Center(child: Text('DebugPage')),
              const SizedBox(height: 16),
              Consumer<UserChangeNotifier>(
                builder: (context, user, child) {
                  return Column(children: [
                    Text('UID:${user.user?.uid ?? "Not Logged In"}'),
                    if(user.user!=null) QrImage(data: user.user!.uid)
                  ]);
                },
              ),
              const SizedBox(height: 16),
              Consumer<ReservationChangeNotifier>(
                builder: (context, reservation, child) {
                  return Text(
                      'Reservation:[${reservation.reservation?.map((reservation) => reservation.reservation_id).join(",") ?? "No Reservation"}]');
                },
              ),
              const SizedBox(height: 16),
              Consumer<PermissionsChangeNotifier>(
                builder: (context, perms, child) {
                  return Text('Permissions:[${perms.permissions.join(",")}]');
                },
              ),
              ElevatedButton(
                  onPressed: () {
                    Provider.of<ReservationChangeNotifier>(context, listen: false).update();
                  },
                  child: const Text("Refresh Reservation")),
              const SizedBox(height: 16),
              Consumer<EventChangeNotifier>(
                builder: (context, event, child) {
                  return Text(
                      'Event:[${event.events?.map((event) => "${event.display_name}(${event.event_id})").join(",") ?? "No Event"}]');
                },
              ),
              ElevatedButton(
                  onPressed: () {
                    Provider.of<EventChangeNotifier>(context, listen: false).updateEvents();
                  },
                  child: const Text("Refresh Event")),
              const SizedBox(height: 16),
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed("/register/phoneVerifier");
                  },
                  child: const Text("PhoneVerifier Page")),
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed("/signup");
                  },
                  child: const Text("SignUp Page")),
            ],
          ),
        ),
      ),
    );
  }
}
