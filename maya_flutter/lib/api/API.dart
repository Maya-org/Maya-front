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
  return await http.post(url, body: body, headers: await headers());
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
      try{
        return MayaUser.fromJson(safeJsonDecode(res));
      }catch(e){
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
