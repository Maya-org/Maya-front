import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:maya_flutter/api/APIResponse.dart';
import 'package:maya_flutter/api/models/Models.dart';
import 'package:maya_flutter/api/processer/CancelProcesser.dart';
import 'package:maya_flutter/api/processer/CheckProcessor.dart';
import 'package:maya_flutter/api/processer/EventProcesser.dart';
import 'package:maya_flutter/api/processer/ForceProcessor.dart';
import 'package:maya_flutter/api/processer/GetReserveProcesser.dart';
import 'package:maya_flutter/api/processer/LookUpProcessor.dart';
import 'package:maya_flutter/api/processer/ModifyProcesser.dart';
import 'package:maya_flutter/api/processer/PermissionsProcesser.dart';
import 'package:maya_flutter/api/processer/PostBindProcessor.dart';
import 'package:maya_flutter/api/processer/PostPermissionsProcessor.dart';
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
  Map<String, String> map = {"first_name": user.firstName, "last_name": user.lastName};

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

Future<APIResponse<bool?>> modifyReserve(List<TicketType> toUpdate, Reservation modifyReservation,
    {String? twoFactorKey}) async {
  Map<String, dynamic> json = {
    "tickets": toUpdate.map((e) => e.toJson()).toList(),
    "reservation_id": modifyReservation.reservation_id,
    if (twoFactorKey != null) "two_factor_key": twoFactorKey
  };
  return await postProcessed("modify", const ModifyProcessor(), body: json);
}

Future<APIResponse<bool?>> cancelReserve(Reservation reservation) {
  Map<String, dynamic> json = {
    "reservation_id": reservation.reservation_id,
  };

  return postProcessed("cancel", const CancelProcessor(), body: json);
}

Future<APIResponse<bool?>> check(Operation operation, Room room, String wristbandID) {
  Map<String, dynamic> json = {
    "operation": operation.operationName,
    "wristbandID": wristbandID,
    "room_id": room.room_id,
  };
  return postProcessed("check", const CheckProcessor(), body: json);
}

Future<APIResponse<List<Room>?>> rooms() {
  return getProcessed("room", const RoomsProcessor());
}

Future<APIResponse<LookUpData?>> lookUp(String userId, String ticketID) {
  return postProcessed("lookup", LookUpProcessor(),
      body: {"user_id": userId, "ticket_id": ticketID});
}

Future<APIResponse<bool?>> postPermission(String targetUserUid, Map<String, bool> permissions) {
  return postProcessed("permissions", PostPermissionsProcessor(),
      body: {"target_user_uid": targetUserUid, "data": permissions});
}

Future<APIResponse<bool?>> postBind(String wristBandID, String reserverID, String ticketID) {
  return postProcessed("bind", PostBindProcessor(),
      body: {"wristbandID": wristBandID, "reserverID": reserverID, "ticketID": ticketID});
}

Future<APIResponse<List<Ticket>?>> force(ReserveRequest request, String? data) {
  Map<String, dynamic> json = request.toJson();
  if (data != null) {
    json["data"] = data;
  }
  return postProcessed("force", ForceProcessor(), body: json);
}

/// For Debugging purposes
Future<Tuple2<Duration, R>> measureTime<R>(Future<R> Function() block) async {
  Stopwatch stopwatch = Stopwatch();
  stopwatch.start();
  R r = await block();
  stopwatch.stop();
  return Tuple2(stopwatch.elapsed, r);
}
