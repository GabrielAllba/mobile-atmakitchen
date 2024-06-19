import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthClient {
  static String baseUrl = 'http://10.0.2.2:8000'; // Ganti sesuai dengan URL base Anda
  static String endpointLogin = '/api/autologin/login'; // Ganti sesuai dengan endpoint login Anda
  static String endpointSendResetEmail = '/api/email/sendResetEmail'; // Ganti sesuai dengan endpoint send reset email Anda

  static Future<http.Response> login(String email, String password) async {
    try {
      final data = {"email": email, "password": password};
      var response = await http.post(
        Uri.parse(baseUrl + endpointLogin),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data),
      );
      return response;
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  static Future<http.Response> sendResetEmail(String email) async {
    try {
      final data = {"email": email};
      var response = await http.post(
        Uri.parse(baseUrl + endpointSendResetEmail),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data),
      );
      return response;
    } catch (e) {
      return Future.error(e.toString());
    }
  }
}