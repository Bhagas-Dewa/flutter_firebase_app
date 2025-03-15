import 'package:flutter/material.dart';
import 'package:flutter_firebase_app/widgets/navbar.dart';
import 'package:flutter_firebase_app/screen/home/createproduct_screen.dart';
import 'package:flutter_firebase_app/screen/home/editproduct_screen.dart';
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
        padding: const EdgeInsets.all(16),
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
              return Card(
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(15),
                  title: Text(
                    product.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  subtitle: Text(
                    'Rp ${product.price.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: Colors.green[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.edit, 
                          color: Colors.blue[600],
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
        backgroundColor: Colors.blue[600],
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
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
      cancelTextColor: Colors.blue,
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