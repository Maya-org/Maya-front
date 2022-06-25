import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:maya_flutter/api/models/Models.dart';

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

Future<Response> post(String path, {Map<String, dynamic>? body}) async {
  Uri url = fullURL(path);
  return await http.post(url, body: jsonEncode(body), headers: await headers());
}

Future<http.Response> register(MayaUser user) async {
  Map<String, String> map = {"firstName": user.firstName, "lastName": user.lastName};

  http.Response res = await post("register", body: map);

  switch (res.statusCode) {
    case 200:
      print("Successfully registered");
      break;
    case 400:
      print("Internal Exception");
      break;
    case 401:
      print("Authentication failed");
      print("User already exists");
      break;
    default:
      print("Unknown error");
      break;
  }
  return res;
}

Future<MayaUser?> user() async {
  http.Response res = await get("user");

  print('user res: ${res.body}');

  switch (res.statusCode) {
    case 200:
      print("Successfully got user");
      try {
        return MayaUser.fromJson(safeJsonDecode(res));
      } catch (e) {
        return null;
      }
    case 401:
      print("Authentication failed");
      return null;
    case 404:
      print("User not found");
      return null;
    default:
      print("Unknown error");
      return null;
  }
}

Future<List<ReservableEvent>?> event() async {
  http.Response res = await get("event");

  print('event res: ${res.body}');

  switch (res.statusCode) {
    case 200:
      print("Successfully got event");
      try {
        return (safeJsonDecode(res) as List<dynamic>)
            .map((e) => ReservableEvent.fromJson(e))
            .toList();
      } catch (e) {
        return null;
      }

    case 401:
      print("Authentication failed");
      return null;
    case 404:
      print("Event not found");
      return null;
    default:
      print("Unknown error");
      return null;
  }
}

Future<List<Reservation>?> getReserve() async {
  Response res = await get("reserve");
  print('reserve res: ${res.body}');

  switch (res.statusCode) {
    case 200:
      print("Successfully got reserve");
      try {
        List<dynamic> arr = safeJsonDecode(res);
        return arr.map((e) => Reservation.fromJson(e)).toList();
      } catch (e) {
        print('error: $e');
        return null;
      }
    case 401:
      print("Authentication failed");
      return null;
    case 404:
      print("Reserve not found");
      return null;
    default:
      print("Unknown error");
      return null;
  }
}

Future<bool> postReserve(Reservation reservation) async {
  Map<String,dynamic> json = reservation.toJson();

  print('Request: ${jsonEncode(json)}');

  Response res = await post("reserve", body: json);

  print('reserve res: ${res.body}');

  switch (res.statusCode) {
    case 200:
      print("Successfully posted reserve");
      return true;
    case 401:
      print("Authentication failed");
      return false;
    case 400:
      print("Internal Exception");
      return false;
    default:
      print("Unknown error");
      return false;
  }
}
