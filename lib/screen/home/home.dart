import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_app/widgets/navbar.dart';
import 'package:flutter_firebase_app/screen/home/createproduct_screen.dart';
import 'package:flutter_firebase_app/screen/home/editproduct_screen.dart';
import 'package:flutter_firebase_app/screen/home/detailproduct_screen.dart';
import 'package:flutter_firebase_app/controller/product_controller.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  final ProductController productController = Get.put(ProductController());
  HomePage({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Daftar Produk',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Color(0xff3E6B99),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.only(right: 16, left: 16, top: 2, bottom: 2),
        child: Obx(() {
          if (productController.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xff3E6B99)),
              ),
            );
          }
          
          if (productController.products.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.inbox_outlined,
                    size: 100,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Tidak ada produk',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            );
          }
          
          return ListView.builder(
            itemCount: productController.products.length,
            itemBuilder: (context, index) {
              final product = productController.products[index];
              return GestureDetector(
                onTap: () {
                  Get.to(() => ProductDetailScreen(product: product));
                },
                child: Card(
                  color: Color.fromARGB(255, 255, 255, 255),
                  elevation: 1,
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Image container
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: _buildProductImage(product.imageBase64),
                        ),
                        
                        SizedBox(width: 16),
                        
                        // Product details - only name and price in list view
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                product.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Rp ${product.price.toStringAsFixed(2)}',
                                style: TextStyle(
                                  color: Color(0xff7BB661),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        // Action buttons
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.edit,
                                color: Color(0xff3E6B99),
                              ),
                              onPressed: () {
                                Get.to(() => EditProductScreen(product: product));
                              },
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.delete,
                                color: Colors.red[600],
                              ),
                              onPressed: () {
                                _showDeleteDialog(product);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }),
      ),
      bottomNavigationBar: const CustomNavBar(initialIndex: 0),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => CreateProductScreen());
        },
        backgroundColor: Color(0xff3E6B99),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
  
  // Helper method to build image from Base64 string
  Widget _buildProductImage(String? imageBase64) {
    if (imageBase64 == null || imageBase64.isEmpty) {
      return Center(
        child: Icon(
          Icons.image_not_supported_outlined, 
          color: Colors.grey[400],
          size: 36,
        ),
      );
    }
    
    try {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.memory(
          base64Decode(imageBase64),
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
          errorBuilder: (context, error, stackTrace) {
            return Center(
              child: Icon(
                Icons.broken_image_outlined, 
                color: Colors.red[300],
                size: 36,
              ),
            );
          },
        ),
      );
    } catch (e) {
      return Center(
        child: Icon(
          Icons.broken_image_outlined, 
          color: Colors.red[300],
          size: 36,
        ),
      );
    }
  }
  
  void _showDeleteDialog(product) {
    Get.defaultDialog(
      title: 'Hapus Produk',
      titleStyle: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
      middleText: 'Anda yakin menghapus produk ${product.name}?',
      textCancel: 'Batal',
      textConfirm: 'Hapus',
      cancelTextColor: Colors.black,
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: () {
        productController.deleteProduct(product.id!);
        Get.back();
      },
      barrierDismissible: false,
    );
  }
}