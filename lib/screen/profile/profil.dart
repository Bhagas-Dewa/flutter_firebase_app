import 'package:flutter/material.dart';
import 'package:flutter_firebase_app/screen/profile/scanner_screen.dart';
import 'package:flutter_firebase_app/screen/profile/video_screen.dart';
import 'package:get/get.dart';
import 'package:flutter_firebase_app/widgets/navbar.dart';
import 'package:flutter_firebase_app/controller/auth_controller.dart';
import 'package:flutter_firebase_app/screen/login_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_firebase_app/controller/profile_controller.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ProfileScreen extends StatelessWidget {
  final AuthController authController = Get.find<AuthController>();
  final ProfileController profilecontroller = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
        centerTitle: true,
      ),
      body: Obx(() {
        if (authController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final user = authController.currentUser.value;
        final String name = user?.name ?? 'User';
        final String email = user?.email ?? '';

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),

              // Profile Avatar
              const CircleAvatar(
                radius: 40,
                backgroundColor: Colors.blue,
                child: Icon(Icons.person, size: 40, color: Colors.white),
              ),

              const SizedBox(height: 20),

              // User Name
              Text(
                name,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              // User Email
              Text(
                email,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),

              const SizedBox(height: 40),

              // Profile menu items
              _buildMenuItem(
                icon: Icons.person_outline,
                title: 'Edit Profil',
                onTap: () {
                  // TODO: Navigate to edit profile
                },
              ),

              _buildMenuItem(
                icon: Icons.video_camera_back_outlined,
                title: 'Video Company',
                onTap: () {
                  Get.to(() => VideoScreen());
                },
              ),


              // Update the Find Us menu item in your ProfileScreen class
              _buildMenuItem(
                icon: Icons.map_outlined,
                title: 'Find Us',
                onTap: () {
                  // Show options dialog
                  Get.dialog(
                    AlertDialog(
                      title: const Text('Location Options'),
                      content: const Text('What would you like to do?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Get.back(); // Close dialog
                            profilecontroller.getCurrentLocation();
                          },
                          child: const Text('Show My Location'),
                        ),
                        TextButton(
                          onPressed: () {
                            Get.back(); // Close dialog
                            profilecontroller.showCompanyLocation();
                          },
                          child: const Text('Find Our Office'),
                        ),
                      ],
                    ),
                  );
                },
              ),
              _buildMenuItem(
                icon: Icons.help_outline,
                title: 'Bantuan',
                onTap: () {
                 profilecontroller.launchURL('https://www.google.com');
                },
              ),
              _buildMenuItem(
                icon: Icons.qr_code_2_outlined,
                title: 'Scan QR Code',
                onTap: () async {
                  final scannedData = await Get.to(() => ScannerScreen());
                  if (scannedData != null) {
                    Get.snackbar('Scan Result', scannedData, snackPosition: SnackPosition.BOTTOM);
                  }
                },
              ),


              const SizedBox(height: 20),

              // Logout Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    await authController.logout();
                    Get.offAll(() => LoginScreen());
                  },
                  icon: const Icon(Icons.logout),
                  label: const Text(
                    'Keluar',
                    style: TextStyle(fontSize: 16),
                  ),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
      bottomNavigationBar: const CustomNavBar(initialIndex: 3),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: ListTile(
        leading: Icon(icon, color: Get.theme.primaryColor),
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }

}
