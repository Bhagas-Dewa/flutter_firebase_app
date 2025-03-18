import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_app/controller/product_controller.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class CreateProductScreen extends StatelessWidget {
  final ProductController productController = Get.find<ProductController>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  
  // For image handling
  final Rx<File?> selectedImage = Rx<File?>(null);
  final ImagePicker _picker = ImagePicker();
  
  CreateProductScreen({Key? key}) : super(key: key);
  
  // Method to pick image from gallery
  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 800, 
      maxHeight: 800,
      imageQuality: 85, 
    );
    
    if (image != null) {
      selectedImage.value = File(image.path);
    }
  }
  
  // Convert image file to base64
  Future<String?> _getBase64Image() async {
    if (selectedImage.value == null) return null;
    
    try {
      final bytes = await selectedImage.value!.readAsBytes();
      return base64Encode(bytes);
    } catch (e) {
      print('Error encoding image: $e');
      return null;
    }
  }

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
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Image picker section
                Obx(() => Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: selectedImage.value == null
                    ? Center(
                        child: IconButton(
                          icon: Icon(
                            Icons.add_photo_alternate,
                            size: 50,
                            color: Colors.grey[600],
                          ),
                          onPressed: _pickImage,
                        ),
                      )
                    : Stack(
                        fit: StackFit.expand,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(
                              selectedImage.value!,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.5),
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                icon: Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                ),
                                onPressed: _pickImage,
                              ),
                            ),
                          ),
                        ],
                      ),
                )),
                
                SizedBox(height: 16),
                
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

                 SizedBox(height: 16),
                
                TextFormField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Deskripsi Produk',
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true,
                  ),
                  maxLines: 5,
                  minLines: 3,
                ),
                
                SizedBox(height: 24),
                
                Obx(() => ElevatedButton(
                  onPressed: productController.isLoading.value
                    ? null
                    : () async {
                        if (_formKey.currentState!.validate()) {
                          // Get base64 image if available
                          final imageBase64 = await _getBase64Image();
                          
                          double price = double.parse(priceController.text);
                          productController.addProduct(
                            nameController.text,
                            price,
                            descriptionController.text,
                            imageBase64,
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
      ),
    );
  }
}