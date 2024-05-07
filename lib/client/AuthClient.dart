import 'package:atma_kitchen/models/user.dart';

import 'dart:convert';
import 'package:http/http.dart';

class AuthClient {
  static final String url = '10.0.2.2:8000';
  static final String endpointregister = '/api/register';
  static final String endpointlogin = '/api/login';
  static final String endpointuser = '/api/user';
}
