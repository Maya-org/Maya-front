import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:maya_flutter/api/APIResponse.dart';
import 'package:maya_flutter/api/models/Models.dart';
import 'package:maya_flutter/api/processer/CancelProcesser.dart';
import 'package:maya_flutter/api/processer/CheckProcessor.dart';
import 'package:maya_flutter/api/processer/EventProcesser.dart';
import 'package:maya_flutter/api/processer/GetReserveProcesser.dart';
import 'package:maya_flutter/api/processer/ModifyProcesser.dart';
import 'package:maya_flutter/api/processer/PermissionsProcesser.dart';
import 'package:maya_flutter/api/processer/PostReserveProcesser.dart';
import 'package:maya_flutter/api/processer/RegisterProcesser.dart';
import 'package:maya_flutter/api/processer/RoomsProcessor.dart';
import 'package:maya_flutter/api/processer/UserProcesser.dart';
import 'package:tuple/tuple.dart';

const endPoint = "https://asia-northeast1-maya-e0346.cloudfunctions.net/";

dynamic safeJsonDecode(Response res) {
  try {
    return jsonDecode(res.body);
  } catch (e) {
    return null;
  }
}

Uri fullURL(String path) {
  Uri uri = Uri.parse(endPoint + path);
  return uri;
}

Future<Map<String, String>> headers() async {
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    String s = await user.getIdToken(true);
    return {
      "Authorization": "Bearer $s",
    };
  } else {
    return {};
  }
}

Future<Response> get(String path) async {
  Uri url = fullURL(path);
  return await http.get(url, headers: await headers());
}

Future<APIResponse<T?>> getProcessed<T>(String path, APIResponseProcessor<T> processor) async {
  Response res = await get(path);
  return processResponse(res, processor);
}

Future<Response> post(String path, {Map<String, dynamic>? body}) async {
  Uri url = fullURL(path);
  return await http.post(url, body: jsonEncode(body), headers: await headers());
}

Future<APIResponse<T?>> postProcessed<T>(String path, APIResponseProcessor<T> processor,
    {Map<String, dynamic>? body}) async {
  Response res = await post(path, body: body);
  return processResponse(res, processor);
}

Future<APIResponse<bool?>> register(MayaUser user) async {
  Map<String, String> map = {"firstName": user.firstName, "lastName": user.lastName};

  return await postProcessed("register", const RegisterProcessor(), body: map);
}

Future<APIResponse<MayaUser?>> user() async {
  return await getProcessed("user", const UserProcessor());
}

Future<APIResponse<List<ReservableEvent>?>> event() async {
  return await getProcessed("event", const EventProcessor());
}

Future<APIResponse<List<Reservation>?>> getReserve() async {
  return await getProcessed("reserve", const GetReserveProcessor());
}

Future<APIResponse<String?>> postReserve(ReserveRequest request) async {
  Map<String, dynamic> json = request.toJson();

  return await postProcessed("reserve", const PostReserveProcessor(), body: json);
}

Future<APIResponse<List<String>?>> getPermissions() async {
  return await getProcessed("permissions", const PermissionsProcessor());
}

Future<APIResponse<bool?>> modifyReserve(
    Reservation reservation, TicketType ticketType, Group toUpdate,
    {String? twoFactorKey}) async {
  Map<String, dynamic> json = {
    "reservation_id": reservation.reservation_id,
    "toUpdate_ticket_type_id": ticketType.ticket_type_id,
    "toUpdate": toUpdate.toJson(),
    if (twoFactorKey != null) "two_factor_key": twoFactorKey
  };
  return await postProcessed("modify", const ModifyProcessor(), body: json);
}

Future<APIResponse<bool?>> cancelReserve(Reservation reservation) {
  Map<String, dynamic> json = {
    "reservation_id": reservation.reservation_id,
  };

  return postProcessed("modify", const CancelProcessor(), body: json);
}

Future<APIResponse<bool?>> check(
    Operation operation, String uid, Room room, String reservationID) {
  Map<String, dynamic> json = {
    "operation": operation.operationName,
    "auth_uid": uid,
    "room_id": room.room_id,
    "reservation_id": reservationID,
  };
  return postProcessed("check", const CheckProcessor(), body: json);
}

Future<APIResponse<List<Room>?>> rooms(){
  return getProcessed("rooms", const RoomsProcessor());
}

/// For Debugging purposes
Future<Tuple2<Duration, R>> measureTime<R>(Future<R> Function() block) async {
  Stopwatch stopwatch = Stopwatch();
  stopwatch.start();
  R r = await block();
  stopwatch.stop();
  return Tuple2(stopwatch.elapsed, r);
}
