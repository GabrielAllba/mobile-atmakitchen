import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:atma_kitchen/models/product.dart';

class ApiService {
  static const String baseUrl = '10.0.2.2:8000';
  static const String endpoint = '/api/product';

  static Future<List<Product>> fetchProducts() async {
    try {
      final response = await http.get(
        Uri.http(baseUrl, endpoint),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body)['product'];
        List<Product> product = body.map((dynamic item) => Product.fromJson(item)).toList();
        return product;
      } else {
        throw Exception('Failed to load products bang');
      }
    } catch (e) {
      return Future.error(e.toString());
    }
  }
}
