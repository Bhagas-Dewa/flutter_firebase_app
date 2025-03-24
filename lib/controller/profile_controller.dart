import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firebase_app/screen/profile/webview_screen.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';



class ProfileController extends GetxController {
  final Rx<String> locationStatus = 'Unknown'.obs;
  late VideoPlayerController videoController;
  final RxBool isVideoPlaying = false.obs;
  final RxBool isVideoInitialized = false.obs;
  final RxString scannedResult = ''.obs;



  @override
  void onInit() {
    super.onInit();
    initializeVideo(); 
  }

  void openWebView(String url, {String title = 'Web View'}) {
  Get.to(() => WebviewScreen(url: url, title: title));
}

  
  // Fungsi untuk membuka URL di browser
  Future <void> launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.inAppBrowserView);
    } else {
      Get.snackbar('Error', 'Tidak dapat membuka URL',
          snackPosition: SnackPosition.BOTTOM);
    }
  }
  
  //Method to handle location permission
  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Get.snackbar(
        'Location Services Disabled', 
        'Enable location services in settings',
        snackPosition: SnackPosition.BOTTOM
      );
      return false;
    }

    // Check for location permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Get.snackbar(
          'Permission Denied', 
          'Location permissions are denied',
          snackPosition: SnackPosition.BOTTOM
        );
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      Get.snackbar(
        'Permission Denied', 
        'Location permissions are permanently denied, open settings to enable',
        snackPosition: SnackPosition.BOTTOM
      );
      return false;
    }

    return true;
  }

  Future<void> getCurrentLocation() async {
     try {
    LocationPermission permission = await Geolocator.requestPermission();
    
    if (permission == LocationPermission.denied) {
      Get.snackbar('Permission Denied', 'Location permission is denied');
      return;
    }
    
    // Then check if location services are enabled
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Get.snackbar('Location Services Disabled', 'Please enable location services');
      return;
    }
    
    Position position = await Geolocator.getCurrentPosition();
    
    final url = 'https://www.google.com/maps/search/?api=1&query=${position.latitude},${position.longitude}';
    launchURL(url);
    
  } catch (e) {
    Get.snackbar('Error', 'Error getting location: $e');
  }
}

  Future<void> showCompanyLocation() async {
    final double companyLatitude = -7.261307; 
    final double companyLongitude = 112.739267;
    
    final url = 'https://www.google.com/maps/search/?api=1&query=$companyLatitude,$companyLongitude';
    await launchURL(url);
  }


  Future<void> initializeVideo() async {
    try {
      videoController = VideoPlayerController.asset('assets/videocompro.mp4');

      await videoController.initialize().then((_) {
        isVideoInitialized.value = true;
        update(); 
      }).catchError((error) {
        Get.snackbar('Error', 'Failed to load video: $error');
      });
    } catch (e) {
      Get.snackbar('Error', 'Error initializing video: $e');
    }
  }

  void playPauseVideo() {
    if (!isVideoInitialized.value) return;

    if (videoController.value.isPlaying) {
      videoController.pause();
      isVideoPlaying.value = false;
    } else {
      videoController.play();
      isVideoPlaying.value = true;
    }
  }


   void setScannedResult(String result) {
    scannedResult.value = result;
    }


  @override
  void onClose() {
    videoController.dispose();
    super.onClose();
  }
  
}

