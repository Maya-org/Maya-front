import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:maya_flutter/api/APIResponse.dart';
import 'package:maya_flutter/api/models/Models.dart';
import 'package:maya_flutter/api/processer/EventProcesser.dart';
import 'package:maya_flutter/api/processer/GetReserveProcesser.dart';
import 'package:maya_flutter/api/processer/PermissionsProcesser.dart';
import 'package:maya_flutter/api/processer/PostReserveProcesser.dart';
import 'package:maya_flutter/api/processer/RegisterProcesser.dart';
import 'package:maya_flutter/api/processer/UserProcesser.dart';

const end_point = "https://us-central1-maya-e0346.cloudfunctions.net/";

dynamic safeJsonDecode(Response res) {
  try {
    return jsonDecode(res.body);
  } catch (e) {
    return null;
  }
}

Uri fullURL(String path) {
  Uri uri = Uri.parse(end_point + path);
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

Future<APIResponse<T?>> getProcessed<T>(String path, APIResponseProcesser<T> processer) async {
  Response res = await get(path);
  return processResponse(res, processer);
}

Future<Response> post(String path, {Map<String, dynamic>? body}) async {
  Uri url = fullURL(path);
  return await http.post(url, body: jsonEncode(body), headers: await headers());
}

Future<APIResponse<T?>> postProcessed<T>(String path, APIResponseProcesser<T> processer,
    {Map<String, dynamic>? body}) async {
  Response res = await post(path, body: body);
  return processResponse(res, processer);
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

Future<APIResponse<bool?>> postReserve(Reservation reservation) async {
  Map<String, dynamic> json = reservation.toJson();

  return await postProcessed("reserve", const PostReserveProcessor(), body: json);
}

Future<APIResponse<List<String>?>> getPermissions() async {
  return await getProcessed("permissions", const PermissionsProcessor());
}
