import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:atma_kitchen/models/transaction.dart';

class ApiService {
  static const String baseUrl = '10.0.2.2:8000'; // Replace with your API base URL
  static const String endpoint = '/api/transactions';

  static Future<List<Transaction>> fetchTransactions() async {
    try {
      final response = await http.get(
        Uri.http(baseUrl, endpoint),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body)['transactions'];
        List<Transaction> transactions = body.map((dynamic item) => Transaction.fromJson(item)).toList();
        return transactions;
      } else {
        throw Exception('Failed to load transactions');
      }
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  static Future<void> updateTransactionStatus(int transactionId, String newStatus) async {
    try {
      final String updateEndpoint = '/api/transactions/status/$transactionId/$newStatus'; // Replace with your update endpoint
      final Uri uri = Uri.http(baseUrl, updateEndpoint);

      Map<String, dynamic> requestBody = {
        'transaction_id': transactionId,
        'new_status': newStatus,
      };

      final response = await http.put(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json',
          // Add any other headers your backend requires, like authorization tokens
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        // Handle success scenario if needed
        print('Transaction status updated successfully');
      } else {
        // Handle error scenario
        throw Exception('Failed to update transaction status');
      }
    } catch (e) {
      throw Exception('Failed to update transaction status: $e');
    }
  }
}
