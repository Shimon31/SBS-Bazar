import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/product_model.dart';
import 'api_constants.dart';

class ProductRepository {
  final http.Client _client;

  ProductRepository({http.Client? client}) : _client = client ?? http.Client();

  /// Fetches all products from the API
  Future<List<Product>> getAllProducts() async {
    try {
      final response = await _client.get(
        Uri.parse(ApiConstants.products),
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body) as List;
        return jsonList
            .map((json) => Product.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Failed to load products. Status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching products: $e');
    }
  }

  /// Fetches products filtered by category ID
  Future<List<Product>> getProductsByCategory(int categoryId) async {
    try {
      final response = await _client.get(
        Uri.parse(ApiConstants.productsByCategory(categoryId)),
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body) as List;
        return jsonList
            .map((json) => Product.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Failed to load products by category. Status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching products by category: $e');
    }
  }
}