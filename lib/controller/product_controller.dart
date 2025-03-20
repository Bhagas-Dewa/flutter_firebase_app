import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:flutter_firebase_app/models/product_model.dart';

class ProductController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final RxList<Product> products = <Product>[].obs;
  final RxList<Product> filteredProducts = <Product>[].obs;
  final RxBool isLoading = false.obs;

  final RxDouble minPrice = 0.0.obs;
  final RxDouble maxPrice = double.infinity.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProducts(); 
  }

  // Read all products
  Future<void> fetchProducts() async {
    isLoading.value = true;
    try {
      final QuerySnapshot snapshot = await _firestore.collection('products').get();
      
      products.value = snapshot.docs.map((doc) {
          return Product.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();

      // Set filteredProducts sama dengan semua produk di awal
      filteredProducts.assignAll(products);


    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to fetch products: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> filteredProductsByPrice(double? minPrice, double? maxPrice) async {
    isLoading.value = true;
    try { 
      this.minPrice.value = minPrice ?? 0.0;
      this.maxPrice.value = maxPrice ?? double.infinity;

      final QuerySnapshot snapshot = await _firestore.collection('products').get();

      List<Product> allProducts = snapshot.docs.map((doc) {
        return Product.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();

      filteredProducts.value = allProducts.where((product) {
        return (minPrice == null || product.price >= minPrice) && 
              (maxPrice == null || product.price <= maxPrice);
      }).toList();

    } catch (e) {
      Get.snackbar(
        'Error', 
        'Gagal memfilter produk berdasarkan harga: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
          }
    finally {
    isLoading.value = false; 
    }
  }

  Future <void> searchProducts(String query) async {
    isLoading.value = true;
    try {
      QuerySnapshot snapshot;
      String searchQuery = query.toLowerCase().trim();

      if (query.isEmpty) {
        snapshot = await _firestore.collection('products').get();
      } else {
        // get data terlebih dahulu
        snapshot = await _firestore.collection('products').get();
        
        // kemudian di filter
        filteredProducts.value = snapshot.docs
          .map((doc) => Product.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .where((product) => product.name.toLowerCase().contains(searchQuery))
          .toList();

        isLoading.value = false;
        return;
      }

       filteredProducts.value = snapshot.docs.map((doc) {
        return Product.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();

    } catch (e) {
      Get.snackbar('Error', 'Gagal mencari Produk: $e', 
      snackPosition: SnackPosition.BOTTOM);
      
    } finally
    {
      isLoading.value = false;
    }
  }
  

  Future<void> addProduct(String name, double price, String description, String? imageBase64) async {
    isLoading.value = true;
    try {
      final product = Product(
        name: name, 
        price: price,
        description: description,
        imageBase64: imageBase64,
        );
      
      await _firestore.collection('products').add(product.toMap()).then((docRef) async {
      // Update dokumen dengan menambahkan ID-nya sendiri
      await docRef.update({'id': docRef.id});
      });
      
      // Refresh the product list
      await fetchProducts();
      
      Get.snackbar(
        'Success',
        'Product added successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to add product: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Update product
  Future<void> updateProduct(String id, String name, double price, String description, String? imageBase64) async {
    isLoading.value = true;
    try {
      final product = Product(
        id: id,
        name: name,
        price: price,
        description: description,
        imageBase64: imageBase64,
        );
      
      await _firestore.collection('products').doc(id).update(product.toMap());
      
      // Refresh the product list
      await fetchProducts();
      
      Get.snackbar(
        'Success',
        'Product updated successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update product: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Delete product
  Future<void> deleteProduct(String id) async {
  isLoading.value = true;
  try {
    await _firestore.collection('products').doc(id).delete();

    // Refresh daftar produk setelah dihapus
    await fetchProducts();

    Get.snackbar(
      'Success',
      'Product deleted successfully',
      snackPosition: SnackPosition.BOTTOM,
    );
  } catch (e) {
    Get.snackbar(
      'Error',
      'Failed to delete product: $e',
      snackPosition: SnackPosition.BOTTOM,
    );
  } finally {
    isLoading.value = false;
    }
  }

  
  

  }
