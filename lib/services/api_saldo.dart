import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiSaldo {
  static const String baseUrl = 'http://10.0.2.2:8000/api';

  static Future<Map<String, dynamic>> getUserBalance(int userId) async {
    final response = await http.get(Uri.parse('$baseUrl/user/$userId/balance'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load balance');
    }
  }

  static Future<List<Map<String, dynamic>>> getWithdrawHistory(int userId) async {
    final response = await http.get(Uri.parse('$baseUrl/user/$userId/withdraw/history'));
    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      throw Exception('Failed to load withdraw history');
    }
  }

  static Future<void> withdrawBalance(int userId, double amount) async {
    final response = await http.post(
      Uri.parse('$baseUrl/user/$userId/withdraw'),
      body: json.encode({'amount': amount}),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to withdraw balance');
    }
  }
}
