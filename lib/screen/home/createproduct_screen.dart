import 'package:flutter/material.dart';
import 'package:flutter_firebase_app/controller/product_controller.dart';
import 'package:get/get.dart';

class CreateProductScreen extends StatelessWidget {
  final ProductController productController = Get.find<ProductController>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambahkan Produk Baru'),
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
                  labelText: 'Product Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter product name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: priceController,
                decoration: InputDecoration(
                  labelText: 'Price',
                  border: OutlineInputBorder(),
                  prefixText: 'Rp ',
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter price';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
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
                          productController.addProduct(
                            nameController.text,
                            price,
                          ).then((_) {
                            Navigator.pop(context);
                          });
                        }
                      },
                child: productController.isLoading.value
                    ? CircularProgressIndicator()
                    : Text('Save Product'),
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