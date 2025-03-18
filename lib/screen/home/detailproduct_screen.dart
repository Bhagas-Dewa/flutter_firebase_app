import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_app/controller/product_controller.dart';
import 'package:flutter_firebase_app/models/product_model.dart';
import 'package:flutter_firebase_app/screen/home/editproduct_screen.dart';
import 'package:flutter_firebase_app/screen/home/pdfhelper.dart';
import 'package:get/get.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;
  final ProductController productController = Get.find<ProductController>();

  ProductDetailScreen({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Produk'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Get.to(() => EditProductScreen(product: product));
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              _showDeleteDialog(context);
            },
          ),
          IconButton(
            icon: Icon(Icons.print),
            onPressed: () {
              PdfHelper.generateAndPrintProductPdf(product);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product image
            Container(
              width: double.infinity,
              height: 300,
              decoration: BoxDecoration(
                color: Colors.grey[200],
              ),
              child: _buildProductImage(),
            ),
            
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product name
                  Text(
                    product.name,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  
                  SizedBox(height: 8),
                  
                  // Product price
                  Text(
                    'Rp ${product.price.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.green[700],
                    ),
                  ),
                  
                  SizedBox(height: 24),
                  
                  // Description heading
                  Text(
                    'Deskripsi',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  
                  SizedBox(height: 8),
                  
                  // Product description
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 251, 251, 251),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      product.description ?? 'Tidak ada deskripsi',
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build image from Base64 string
  Widget _buildProductImage() {
    if (product.imageBase64 == null || product.imageBase64!.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.image_not_supported_outlined, 
              color: Colors.grey[400],
              size: 64,
            ),
            SizedBox(height: 16),
            Text(
              'Tidak ada gambar',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }
    
    try {
      return Image.memory(
        base64Decode(product.imageBase64!),
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (context, error, stackTrace) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.broken_image_outlined, 
                  color: Colors.red[300],
                  size: 64,
                ),
                SizedBox(height: 16),
                Text(
                  'Gambar tidak dapat ditampilkan',
                  style: TextStyle(
                    color: Colors.red[300],
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          );
        },
      );
    } catch (e) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.broken_image_outlined, 
              color: Colors.red[300],
              size: 64,
            ),
            SizedBox(height: 16),
            Text(
              'Gambar tidak dapat ditampilkan',
              style: TextStyle(
                color: Colors.red[300],
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }
  }

  void _showDeleteDialog(BuildContext context) {
    Get.defaultDialog(
      title: 'Hapus Produk',
      titleStyle: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
      middleText: 'Anda yakin menghapus produk ${product.name}?',
      textCancel: 'Batal',
      textConfirm: 'Hapus',
      cancelTextColor: Colors.blue,
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: () {
        productController.deleteProduct(product.id!);
        Get.back(); // Close dialog
        Get.back(); // Return to products list
      },
      barrierDismissible: false,
    );
  }
}