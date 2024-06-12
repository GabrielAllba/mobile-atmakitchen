import 'dart:convert';
import 'package:http/http.dart';

class RoleClient {
  static String url = '10.0.2.2:8000';
  static String endpointlogin = '/api/admin/role';

  static Future<Response> getById(int id) async {
    try {
      var response = await get(
        Uri.http(url, '$endpointlogin/$id'),
        headers: {"Content-Type": "application/json"},
      );
      return response;
    } catch (e) {
      return Future.error(e.toString());
    }
  }
}