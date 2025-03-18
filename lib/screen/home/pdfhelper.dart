import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_firebase_app/models/product_model.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'dart:convert';

class PdfHelper {
  static Future<void> generateAndPrintProductPdf(Product product) async {
    final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);

    // Decode base64 image if exists
    pw.ImageProvider? imageProvider;
    if (product.imageBase64 != null && product.imageBase64!.isNotEmpty) {
      try {
        final imageBytes = base64Decode(product.imageBase64!);
        imageProvider = pw.MemoryImage(imageBytes);
      } catch (e) {
        print('Error decoding image: $e');
      }
    }

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Product Title
              pw.Text(
                product.name,
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 20),

              // Product Image (if available)
              if (imageProvider != null)
                pw.Container(
                  width: 300,
                  height: 300,
                  child: pw.Image(imageProvider),
                ),
              pw.SizedBox(height: 20),

              // Product Price
              pw.Text(
                'Price: Rp ${product.price.toStringAsFixed(2)}',
                style: pw.TextStyle(
                  fontSize: 18,
                  color: PdfColors.green,
                ),
              ),
              pw.SizedBox(height: 20),

              // Product Description
              pw.Text(
                'Description:',
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.Text(
                product.description ?? 'No description available',
                style: pw.TextStyle(fontSize: 16),
              ),
            ],
          );
        },
      ),
    );

    // Print the PDF
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }
}