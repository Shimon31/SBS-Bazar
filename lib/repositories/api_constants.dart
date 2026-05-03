class ApiConstants {
  // Private constructor — this class should never be instantiated
  ApiConstants._();


  static const String baseUrl = 'https://api.escuelajs.co/api/v1';

  static const String products = '$baseUrl/products';


  static String productsByCategory(int categoryId) =>
      '$baseUrl/products/?categoryId=$categoryId';

  /// GET all categories
  /// Example: GET /categories
  static const String categories = '$baseUrl/categories';
}