import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_app/controller/product_controller.dart';
import 'package:flutter_firebase_app/screen/home/home.dart';
import 'package:get/get.dart';
import 'package:flutter_firebase_app/models/product_model.dart';
import 'package:image_picker/image_picker.dart';

class EditProductScreen extends StatelessWidget {
  final Product product;
  final ProductController productController = Get.find<ProductController>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  
  // For image handling
  final Rx<File?> selectedImage = Rx<File?>(null);
  final Rx<String?> existingImageBase64 = Rx<String?>(null);
  final ImagePicker _picker = ImagePicker();
  
  EditProductScreen({required this.product}) {
    nameController.text = product.name;
    priceController.text = product.price.toString();
    existingImageBase64.value = product.imageBase64;
    descriptionController.text = product.description;
  }
  
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
      existingImageBase64.value = null; 
    }
  }
  
  // Convert image file to base64
  Future<String?> _getBase64Image() async {
    if (selectedImage.value != null) {
      try {
        final bytes = await selectedImage.value!.readAsBytes();
        return base64Encode(bytes);
      } catch (e) {
        print('Error encoding image: $e');
        return null;
      }
    }
    
    return existingImageBase64.value;
  }
  
  // Remove current image
  void _removeImage() {
    selectedImage.value = null;
    existingImageBase64.value = null;
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
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Obx(() {
                  // Case 1: New image selected
                  if (selectedImage.value != null) {
                    return _buildImageContainer(
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(
                              selectedImage.value!,
                              fit: BoxFit.cover,
                            ),
                          ),
                          _buildImageControlButtons(context),
                        ],
                      ),
                    );
                  }
                  // Case 2: Existing image from database
                  else if (existingImageBase64.value != null && existingImageBase64.value!.isNotEmpty) {
                    return _buildImageContainer(
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.memory(
                              base64Decode(existingImageBase64.value!),
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Center(
                                  child: Icon(
                                    Icons.broken_image_outlined, 
                                    color: Colors.red[300],
                                    size: 50,
                                  ),
                                );
                              },
                            ),
                          ),
                          _buildImageControlButtons(context),
                        ],
                      ),
                    );
                  }
                  // Case 3: No image
                  else {
                    return _buildImageContainer(
                      child: Center(
                        child: IconButton(
                          icon: Icon(
                            Icons.add_photo_alternate,
                            size: 50,
                            color: Colors.grey[600],
                          ),
                          onPressed: _pickImage,
                        ),
                      ),
                    );
                  }
                }),
                
                SizedBox(height: 16),
                
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
                          // Get base64 image
                          final imageBase64 = await _getBase64Image();
                          
                          double price = double.parse(priceController.text);
                          productController.updateProduct(
                            product.id!,
                            nameController.text,
                            price,
                            descriptionController.text,
                            imageBase64,
                          ).then((_) {
                            Get.to(HomePage());
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
      ),
    );
  }
  
  // Helper method to create image container with consistent styling
  Widget _buildImageContainer({required Widget child}) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: child,
    );
  }
  
  // Helper method for the image edit/remove buttons
  Widget _buildImageControlButtons(BuildContext context) {
    return Positioned(
      top: 8,
      right: 8,
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Icon(Icons.edit, color: Colors.white),
              onPressed: _pickImage,
              tooltip: 'Change Image',
            ),
          ),
          SizedBox(width: 8),
          Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Icon(Icons.delete, color: Colors.white),
              onPressed: _removeImage,
              tooltip: 'Remove Image',
            ),
          ),
        ],
      ),
    );
  }
}