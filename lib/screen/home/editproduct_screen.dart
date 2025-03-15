import 'package:flutter/material.dart';
import 'package:flutter_firebase_app/controller/product_controller.dart';
import 'package:get/get.dart';
import 'package:flutter_firebase_app/models/product_model.dart';

class EditProductScreen extends StatelessWidget {
  final Product product;
  final ProductController productController = Get.find<ProductController>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  EditProductScreen({required this.product}) {
    nameController.text = product.name;
    priceController.text = product.price.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Produk'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Nama Produk',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan nama produk';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: priceController,
                decoration: InputDecoration(
                  labelText: 'Harga',
                  border: OutlineInputBorder(),
                  prefixText: 'Rp ',
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan harga';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Masukkan angka valid';
                  }
                  return null;
                },
              ),
              SizedBox(height: 24),
              Obx(() => ElevatedButton(
                onPressed: productController.isLoading.value
                    ? null
                    : () {
                        if (_formKey.currentState!.validate()) {
                          double price = double.parse(priceController.text);
                          productController.updateProduct(
                            product.id!,
                            nameController.text,
                            price,
                          ).then((_) {
                            Navigator.pop(context);
                          });
                        }
                      },
                child: productController.isLoading.value
                    ? CircularProgressIndicator()
                    : Text('Update Produk'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }
}