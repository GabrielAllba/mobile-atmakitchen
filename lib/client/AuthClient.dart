import 'dart:convert';
import 'package:http/http.dart';

class AuthClient {
  static String url = '10.0.2.2:8000';
  static String endpointlogin = '/api/autologin/login';

  static Future<Response> login(String email, String password) async {
    try {
      final data = {"email": email, "password": password};
      print(data);
      var response = await post(
        Uri.http(url, endpointlogin),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data),
      );
      return response;
    } catch (e) {
      return Future.error(e.toString());
    }
  }
}
