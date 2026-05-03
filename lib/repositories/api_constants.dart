class ApiConstants {
  ApiConstants._();

  static const String baseUrl = 'https://api.escuelajs.co/api/v1';

  static const String products = '$baseUrl/products';

  static String productsByCategory(int categoryId) =>
      '$baseUrl/products/?categoryId=$categoryId';

  static const String categories = '$baseUrl/categories';
}
