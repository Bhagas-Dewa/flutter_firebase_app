import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  String? id;
  final String name;
  final double price;
  final String description;
  final String? imageBase64;

  Product({
    this.id,
    required this.name,
    required this.price,
    required this.description,
    this.imageBase64,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
      'description': description, 
      'imageBase64': imageBase64,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map, String docId) {
    return Product(
      id: docId,
      name: map['name'] ?? '',
      price: (map['price'] ?? 0.0).toDouble(),
      description: map['description'] ?? '',
      imageBase64: map['imageBase64'],
    );
  }
}
