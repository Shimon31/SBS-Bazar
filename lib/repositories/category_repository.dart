import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/category_model.dart';
import 'api_constants.dart';

class CategoryRepository {
  final http.Client _client;

  CategoryRepository({http.Client? client}) : _client = client ?? http.Client();

  /// Fetches all categories from the API
  Future<List<Category>> getAllCategories() async {
    try {
      final response = await _client.get(
        Uri.parse(ApiConstants.categories),
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body) as List;
        return jsonList
            .map((json) => Category.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Failed to load categories. Status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching categories: $e');
    }
  }
}