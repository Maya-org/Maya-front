import 'package:flutter/material.dart';
import 'package:maya_flutter/api/API.dart';
import 'package:maya_flutter/api/models/Models.dart';
import 'package:maya_flutter/ui/APIResponseHandler.dart';
import 'package:maya_flutter/ui/AsyncButton.dart';
import 'package:provider/provider.dart';

import '../api/APIResponse.dart';
import '../models/UserChangeNotifier.dart';
import '../ui/StyledText.dart';
import '../ui/UI.dart';

class DebugPage extends StatefulWidget {
  const DebugPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _DebugPageState();
}

class _DebugPageState extends State<DebugPage> {
  String? _firstName;
  String? _lastName;

  @override
  void initState() {
    super.initState();
  }

  Future<APIResponse<MayaUser?>> _updateName() async {
    return await user();
  }

  void _processUpdateName(dynamic r) {
    r as APIResponse<MayaUser?>;
    handleVoid<MayaUser?>(
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

  void _handleEvents(dynamic r) {
    r as APIResponse<List<ReservableEvent>?>;
    handleVoid<List<ReservableEvent>?>(
        context,
        r,
        (p0) => {
              showOKDialog(context,
                  title: const Text("イベント一覧"),
                  body: StyledTextWidget.fromStringOne((p0 as List<ReservableEvent>).toString()))
            });
  }

  Future<APIResponse<List<Reservation>?>> _getReservations() async {
    return await getReserve();
  }

  void _handleGetReservations(dynamic r) {
    r as APIResponse<List<Reservation>?>;
    handleVoid<List<Reservation>?>(
        context,
        r,
        (p0) => {
              showOKDialog(context,
                  title: const Text("予約一覧"),
                  body: StyledTextWidget.fromStringOne((p0 as List<Reservation>).toString()))
            });
  }

  Future<APIResponse<String?>> _postReservation() async {
    return await postReserve(ReserveRequest.fromEvent(
        ReservableEvent(
            event_id: "gSpLm6iBDEQKR5K1Etqj",
            display_name: "予約のテスト",
            date_start: TimeStamp.now(),
            taken_capacity: 0,
            reservations: []),
        Group([Guest(GuestType.Parent)])));
  }

  void _handlePostReservation(dynamic r) {
    r as APIResponse<String?>;
    handleVoid<String?>(context, r,
        (p0) => {showOKDialog(context, title: const Text("予約確認"), body: Text("予約しました\\\n予約ID: $p0"))});
  }

  Future<APIResponse<List<String>?>> _getPermissions() async {
    return await getPermissions();
  }

  void _handleGetPermissions(dynamic r) {
    r as APIResponse<List<String>?>;
    handleVoid<List<String>?>(
        context,
        r,
        (p0) => {
              showOKDialog(context,
                  title: const Text("権限確認"),
                  body: StyledTextWidget.fromStringOne((p0 as List<String>).toString()))
            });
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
            const SizedBox(height: 10),
            const Text("電話番号:"),
            Consumer<UserChangeNotifier>(
              builder: (context, user, _) => Text(user.user?.phoneNumber ?? ""),
            ),
            const Text("UID:"),
            Consumer<UserChangeNotifier>(
              builder: (context, user, _) => Text(user.user?.uid ?? ""),
            ),
            const SizedBox(height: 10),
            const Text("名前:"),
            Text("${_firstName ?? ""} ${_lastName ?? ""}"),
            const SizedBox(height: 10),
            AsyncButton<APIResponse<MayaUser?>>(
                notLoadingButtonContent: const Text("名前取得"),
                asyncTask: _updateName,
                after: (r) => {_processUpdateName(r)}),
            const SizedBox(height: 10),
            AsyncButton(
                notLoadingButtonContent: const Text("イベント取得"),
                asyncTask: _getEvents,
                after: _handleEvents),
            const SizedBox(height: 10),
            AsyncButton(
                notLoadingButtonContent: const Text("予約取得"),
                asyncTask: _getReservations,
                after: _handleGetReservations),
            const SizedBox(height: 10),
            AsyncButton(
                notLoadingButtonContent: const Text("予約登録"),
                asyncTask: _postReservation,
                after: _handlePostReservation),
            const SizedBox(height: 10),
            AsyncButton(
              notLoadingButtonContent: const Text("権限取得"),
              asyncTask: _getPermissions,
              after: _handleGetPermissions,
            )
          ],
        )),
      ),
    );
  }
}
