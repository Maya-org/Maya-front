import 'package:flutter/material.dart';
import 'package:maya_flutter/api/API.dart';
import 'package:maya_flutter/api/models/Models.dart';
import 'package:maya_flutter/ui/APIResponceHandler.dart';
import 'package:maya_flutter/ui/AsyncButton.dart';
import 'package:provider/provider.dart';

import '../api/APIResponse.dart';
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

  Future<APIResponse<MayaUser?>> _updateName() async {
    return await user();
  }

  void _processUpdateName(dynamic r) {
    r as APIResponse<MayaUser?>;
    handle<MayaUser?>(
        context,
        r,
        (p0) => {
              setState(() {
                _firstName = p0?.firstName;
                _lastName = p0?.lastName;
              })
            });
  }

  Future<APIResponse<List<ReservableEvent>?>> _getEvents() async {
    return await event();
  }

  void _processEvents(dynamic r) {
    r as APIResponse<List<ReservableEvent>?>;
    handle<List<ReservableEvent>?>(
        context,
        r,
        (p0) => {
              setState(() {
                es = p0;
              })
            });
  }

  Future<APIResponse<List<Reservation>?>> _getReservations() async {
    return await getReserve();
  }

  void _handleGetReservations(dynamic r) {
    r as APIResponse<List<Reservation>?>;
    handle<List<Reservation>?>(
        context,
        r,
        (p0) => {
              setState(() {
                rs = p0;
              })
            });
  }

  Future<APIResponse<bool?>> _postReservation() async {
    return await postReserve(Reservation(
        reservation_id: "randomreservationid",
        event: ReservableEvent(
            event_id: "gSpLm6iBDEQKR5K1Etqj",
            display_name: "予約のテスト",
            date_start: TimeStamp.now(),
            taken_capacity: 0,
            reservations: []),
        group_data: Group([Guest(GuestType.Parent)])));
  }

  void _handlePostReservation(dynamic r) {
    r as APIResponse<bool?>;
    handle<bool?>(context, r,
        (p0) => {showOKDialog(context, title: const Text("予約確認"), body: const Text("予約しました"))});
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
                notLoadingButtonContent: Text("名前取得"),
                asyncTask: _updateName,
                after: _processUpdateName),
            SizedBox(height: 10),
            Text("イベント一覧:"),
            Text(es?.toString() ?? ""),
            SizedBox(height: 10),
            AsyncButton(
                notLoadingButtonContent: Text("イベント取得"),
                asyncTask: _getEvents,
                after: _processEvents),
            SizedBox(height: 10),
            Text("予約一覧:"),
            Text(rs?.toString() ?? ""),
            SizedBox(height: 10),
            AsyncButton(
                notLoadingButtonContent: Text("予約取得"),
                asyncTask: _getReservations,
                after: _handleGetReservations),
            SizedBox(height: 10),
            AsyncButton(
                notLoadingButtonContent: Text("予約登録"),
                asyncTask: _postReservation,
                after: _handlePostReservation),
          ],
        )),
      ),
    );
  }
}
