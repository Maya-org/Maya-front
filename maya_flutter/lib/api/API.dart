import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:maya_flutter/api/models/Models.dart';

const end_point = "https://us-central1-maya-e0346.cloudfunctions.net/";

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

Future<void> register(MayaUser user) async {
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
  print(res.body);
}
