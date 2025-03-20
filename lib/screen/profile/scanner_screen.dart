import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class ScannerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Scan QR Code"),
      ),
      body: MobileScanner(
        onDetect: (BarcodeCapture capture) {
          final List<Barcode> barcodes = capture.barcodes;
          if (barcodes.isNotEmpty) {
            final String scannedData = barcodes.first.rawValue ?? "No Data";
            _showScanResultDialog(scannedData);
          }
        },
      ),
    );
  }

  void _showScanResultDialog(String scannedData) {
    Get.dialog(
      AlertDialog(
        title: Text("QR Code Scanned"),
        content: Text("Data: $scannedData"),
        actions: [
          TextButton(
            onPressed: () {
              Get.back(); 
            },
            child: Text("Tutup"),
          ),
          if (scannedData.startsWith("http")) 
            TextButton(
              onPressed: () {
                Get.back();
                _openURL(scannedData);
              },
              child: Text("Buka Link"),
            ),
          TextButton(
            onPressed: () {
              Get.back();
              _copyToClipboard(scannedData);
            },
            child: Text("Salin"),
          ),
        ],
      ),
    );
  }

  void _openURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      Get.snackbar("Error", "Tidak dapat membuka URL", snackPosition: SnackPosition.BOTTOM);
    }
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    Get.snackbar("Disalin", "Teks telah disalin ke clipboard", snackPosition: SnackPosition.BOTTOM);
  }
}
