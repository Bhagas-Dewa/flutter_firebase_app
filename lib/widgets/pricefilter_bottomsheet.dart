import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_firebase_app/controller/product_controller.dart';

class PriceFilterBottomSheet extends StatefulWidget {
  final ProductController productController;

  const PriceFilterBottomSheet({
    Key? key, 
    required this.productController
  }) : super(key: key);

  @override
  _PriceFilterBottomSheetState createState() => _PriceFilterBottomSheetState();
}

class _PriceFilterBottomSheetState extends State<PriceFilterBottomSheet> {
  late TextEditingController minPriceController;
  late TextEditingController maxPriceController;

  @override
  void initState() {
    super.initState();
    minPriceController = TextEditingController();
    maxPriceController = TextEditingController();
  }

  @override
  void dispose() {
    minPriceController.dispose();
    maxPriceController.dispose();
    super.dispose();
  }

  void _applyPriceFilter() {
    // Apply price filter
    double? minPrice = minPriceController.text.isNotEmpty 
        ? double.tryParse(minPriceController.text) 
        : null;
    double? maxPrice = maxPriceController.text.isNotEmpty 
        ? double.tryParse(maxPriceController.text) 
        : null;
    
    widget.productController.filteredProductsByPrice(minPrice, maxPrice);
    Navigator.pop(context);
  }

  void _resetFilter() {
    // Reset filter
    minPriceController.clear();
    maxPriceController.clear();
    widget.productController.fetchProducts();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        top: 20,
        left: 20,
        right: 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Filter Harga Produk',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: minPriceController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Harga Minimum',
                    border: OutlineInputBorder(),
                    prefixText: 'Rp ',
                  ),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: maxPriceController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Harga Maksimum',
                    border: OutlineInputBorder(),
                    prefixText: 'Rp ',
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: _resetFilter,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[300],
                ),
                child: Text('Reset', style: TextStyle(color: Colors.black)),
              ),
              ElevatedButton(
                onPressed: _applyPriceFilter,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xff3E6B99),
                ),
                child: Text(
                  'Terapkan',
                  style: TextStyle(color: Colors.white),
                  ),
              ),
            ],
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}

// Fungsi helper untuk menampilkan bottom sheet
void showPriceFilterBottomSheet(BuildContext context, ProductController productController) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => PriceFilterBottomSheet(productController: productController),
  );
}