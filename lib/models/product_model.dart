import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  String? id;
  final String name;
  final double price;

  Product({
    this.id,
    required this.name,
    required this.price,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map, String docId) {
    return Product(
      id: docId,
      name: map['name'] ?? '',
      price: (map['price'] ?? 0.0).toDouble(),
    );
  }
}
