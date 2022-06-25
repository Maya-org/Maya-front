import 'package:flutter/material.dart';
import 'package:maya_flutter/api/API.dart';
import 'package:maya_flutter/api/models/Models.dart';
import 'package:maya_flutter/ui/AsyncButton.dart';
import 'package:provider/provider.dart';

import '../models/UserChangeNotifier.dart';
import '../ui/UI.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String? _firstName;
  String? _lastName;
  List<ReservableEvent>? es;
  List<Reservation>? rs;

  @override
  void initState() {
    super.initState();
  }

  Future<void> updateName() async {
    MayaUser? us = await user();
    if (us != null) {
      setState(() {
        _firstName = us.firstName;
        _lastName = us.lastName;
      });
    } else {
      setState(() {
        _firstName = "none";
        _lastName = "none";
      });
    }
  }

  Future<void> _getEvents() async {
    List<ReservableEvent>? events = await event();
    setState(() {
      es = events;
    });
  }

  Future<void> _getReservations() async {
    List<Reservation>? reservations = await getReserve();
    setState(() {
      rs = reservations;
    });
  }

  Future<bool> _postReservation() async {
    bool b = await postReserve(Reservation(
        reservation_id:"randomreservationid",
        event:ReservableEvent(
            event_id:"gSpLm6iBDEQKR5K1Etqj",
            display_name:"予約のテスト",
            date_start:TimeStamp.now(),
            taken_capacity:0,
            reservations:[]
      ),
        group_data:Group(
        [Guest(GuestType.Parent)]
      )
    ));
    return b;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox.expand(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text("認証完了！！！！"),
            SizedBox(height: 10),
            Text("電話番号:"),
            Consumer<UserChangeNotifier>(
              builder: (context, user, _) => Text(user.user?.phoneNumber ?? ""),
            ),
            Text("UID:"),
            Consumer<UserChangeNotifier>(
              builder: (context, user, _) => Text(user.user?.uid ?? ""),
            ),
            SizedBox(height: 10),
            Text("名前:"),
            Text("${_firstName ?? ""} ${_lastName ?? ""}"),
            SizedBox(height: 10),
            AsyncButton(
                notLoadingButtonContent: Text("名前取得"), asyncTask: updateName, after: (r) {}),
            SizedBox(height: 10),
            Text("イベント一覧:"),
            Text(es?.toString() ?? ""),
            SizedBox(height: 10),
            AsyncButton(
                notLoadingButtonContent: Text("イベント取得"), asyncTask: _getEvents, after: (r) {}),
            SizedBox(height: 10),
            Text("予約一覧:"),
            Text(rs?.toString() ?? ""),
            SizedBox(height: 10),
            AsyncButton(
                notLoadingButtonContent: Text("予約取得"), asyncTask: _getReservations, after: (r) {}),
            SizedBox(height: 10),
            AsyncButton(
                notLoadingButtonContent: Text("予約登録"), asyncTask: _postReservation, after: (r) {
              showOKDialog(context,title:Text("Result:$r"));
            }),
          ],
        )),
      ),
    );
  }
}
