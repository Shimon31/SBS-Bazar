import 'package:flutter/foundation.dart' hide Category;
import 'package:flutter/material.dart';

import 'category_model.dart';

class Product {
  final int id;
  final String title;
  final double price;
  final String description;
  final Category category;
  final List<String> images;

  const Product({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.images,
  });

  String get imageUrl => images.isNotEmpty ? images.first : '';

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int,
      title: json['title'] as String,
      price: (json['price'] as num).toDouble(),
      description: json['description'] as String,
      category: Category.fromJson(json['category'] as Map<String, dynamic>),
      images: List<String>.from(json['images'] as List),
    );
  }

  @override
  String toString() => 'Product(id: $id, title: $title, price: $price)';
}