import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiSaldo {
  static const String baseUrl = 'http://10.0.2.2:8000'; // Tambahkan skema HTTP di sini
  static const String endpoint = 'api/users';

  static Future<double> getUserBalance(int userId) async {
  final response = await http.get(Uri.parse('$baseUrl/$endpoint/$userId/balance'));
  if (response.statusCode == 200) {
    dynamic responseData = json.decode(response.body);
    double balance = responseData['balance'].toDouble(); // Convert balance to double
    return balance;
  } else {
    throw Exception('Failed to load balance');
  }
}

  static Future<List<Map<String, dynamic>>> getWithdrawHistory(int userId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/$endpoint/$userId/withdraw/history'));
      
      if (response.statusCode == 200) {
        List<dynamic> responseData = json.decode(response.body);
        List<Map<String, dynamic>> history = responseData.map((item) {
          return {
            'amount': item['amount'].toDouble(), // Convert amount to double if necessary
            'created_at': item['created_at'], // Adjust to match the field name from backend
            'status': item['status'], // Include status
            'bank_name': item['bank_name'], // Include bank name
            'account_no': item['account_no'], // Include account number
          };
        }).toList();
        return history;
      } else {
        throw Exception('Failed to load withdraw history');
      }
    } catch (e) {
      throw Exception('Failed to load withdraw history: $e');
    }
  }



  static Future<void> withdrawBalance(int userId, double amount, String bankName, String accountNo) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/$endpoint/$userId/withdraw'),
        body: json.encode({
          'amount': amount,
          'bank_name': bankName,
          'account_no': accountNo,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to withdraw balance');
      }
    } catch (e) {
      throw Exception('Failed to withdraw balance: $e');
    }
  }
}