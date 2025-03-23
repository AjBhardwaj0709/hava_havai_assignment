import 'dart:convert';

class Product {
  final int id;
  final String tittle;
  final String description;
  final String brand;
  final String thumbnail;
  final double price;
  final double discountPercentage;

  Product({
    required this.id,
    required this.brand,
    required this.tittle,
    required this.description,
    required this.thumbnail,
    required this.price,
    required this.discountPercentage,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      tittle: json['title'],
      description: json['description'],
      thumbnail: json['thumbnail'],
      brand: json['brand'],
      price: json['price'].toDouble(),
      discountPercentage: json['discountPercentage'].toDouble(),
    );
  }
}
