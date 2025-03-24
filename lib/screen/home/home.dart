import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_app/models/product_model.dart';
import 'package:flutter_firebase_app/widgets/navbar.dart';
import 'package:flutter_firebase_app/screen/home/createproduct_screen.dart';
import 'package:flutter_firebase_app/screen/home/editproduct_screen.dart';
import 'package:flutter_firebase_app/screen/home/detailproduct_screen.dart';
import 'package:flutter_firebase_app/controller/product_controller.dart';
import 'package:get/get.dart';
import 'package:flutter_firebase_app/widgets/pricefilter_bottomsheet.dart';
import 'package:share_plus/share_plus.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);
  
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ProductController productController = Get.put(ProductController());
  final TextEditingController searchController = TextEditingController();

  void _showPriceFilterBottomSheet() {
  showPriceFilterBottomSheet(context, productController);
  }
  
  @override
  void initState() {
    super.initState();
    searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
  
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
        padding: const EdgeInsets.only(right: 16, left: 16, top: 12, bottom: 2),
        child: Column(
          children: [
           Container(
              width: double.infinity,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: searchController,
                      onChanged: (value) => productController.searchProducts(value.toLowerCase().trim()),
                      decoration: InputDecoration(
                        hintText: "Cari Produk...",
                        prefixIcon: Icon(Icons.search),
                        suffixIcon: searchController.text.isNotEmpty
                          ? IconButton(
                              icon: Icon(Icons.clear),
                              onPressed: () {
                                searchController.clear();
                                productController.searchProducts('');
                              },
                            )
                          : null,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Container(
                    decoration: BoxDecoration(
                      color: Color(0xff3E6B99),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: IconButton(
                      icon: Icon(Icons.filter_list, color: Colors.white),
                      onPressed: _showPriceFilterBottomSheet,
                    ),
                  ),
                ],
              ),
            ), 
            SizedBox(height: 10),
            Expanded(
              child: Obx(() {
                if (productController.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xff3E6B99)),
                    ),
                  );
                }

                final displayProducts = productController.filteredProducts;
                
                if (displayProducts.isEmpty) {
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
                  itemCount: displayProducts.length,
                  itemBuilder: (context, index) {
                    final product = displayProducts[index];
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
                          padding: const EdgeInsets.only(top: 4, bottom: 4, left: 8, right: 8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Image container
                              Container(
                                width: 90,
                                height: 120,
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
                                        fontSize: 24,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Rp ${product.price.toStringAsFixed(2)}',
                                      style: TextStyle(
                                        fontSize: 16,
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
                                      size: 20,
                                    ),
                                    onPressed: () {
                                      Get.to(() => EditProductScreen(product: product));
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.red[600],
                                      size: 20,
                                    ),
                                    onPressed: () {
                                      productController.deleteProduct(product.id!);
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.share,
                                      color: Colors.black,
                                      size: 20
                                      ),
                                    onPressed: () {
                                      productController.shareProduct(product);
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

          ],
        ),
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
  
}