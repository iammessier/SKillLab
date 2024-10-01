import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ApiService {
  final String baseUrl = 'http://172.20.10.4:5000';


  Future<List<Product>> fetchProducts(String query) async {
    final response = await http.get(Uri.parse('$baseUrl/search/$query'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => Product.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  // Compare selected products
  Future<List<Product>> compareProducts(List<String> links) async {
    final response = await http.post(
      Uri.parse('$baseUrl/compare'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'links': links}),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => Product.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load comparison data');
    }
  }
}
