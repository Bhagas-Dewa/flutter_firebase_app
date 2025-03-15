import 'package:flutter/material.dart';
import 'package:flutter_firebase_app/widgets/navbar.dart';
import 'package:flutter_firebase_app/controller/auth_controller.dart';
import 'package:flutter_firebase_app/models/user_model.dart';
import 'package:get/get.dart';
import 'package:flutter_firebase_app/screen/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthController _authController = AuthController();
  UserModel? _userData;
  
  @override
  void initState() {
    super.initState();
    _loadUserData();
    
    // Listen to loading state changes
    _authController.isLoading.addListener(_onLoadingChanged);
    
    // Listen to error messages
    _authController.errorMessage.addListener(_onErrorMessageChanged);
  }
  
  @override
  void dispose() {
    // Remove listeners
    _authController.isLoading.removeListener(_onLoadingChanged);
    _authController.errorMessage.removeListener(_onErrorMessageChanged);
    super.dispose();
  }
  
  void _onLoadingChanged() {
    if (mounted) {
      setState(() {});
    }
  }
  
  void _onErrorMessageChanged() {
    final errorMsg = _authController.errorMessage.value;
    if (errorMsg != null && errorMsg.isNotEmpty && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMsg),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _loadUserData() async {
    final userData = await _authController.getCurrentUser();
    if (mounted) {
      setState(() {
        _userData = userData;
      });
    }
  }

  Future<void> _handleLogout() async {
    final success = await _authController.logout(context);
    
    if (success && mounted) {
      // Navigate to login screen
      Get.offAll(() => LoginScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isLoading = _authController.isLoading.value;
    final String name = _userData?.name ?? 'User';
    final String email = _userData?.email ?? '';
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
        centerTitle: true,
      ),
      body: isLoading 
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  
                  // Profile Avatar
                  const CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.blue,
                    child: Icon(Icons.person, size: 60, color: Colors.white),
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
                    icon: Icons.notification_important_outlined,
                    title: 'Notifikasi',
                    onTap: () {
                      // TODO: Navigate to notifications
                    },
                  ),
                  
                  _buildMenuItem(
                    icon: Icons.security_outlined,
                    title: 'Keamanan',
                    onTap: () {
                      // TODO: Navigate to security settings
                    },
                  ),
                  
                  _buildMenuItem(
                    icon: Icons.help_outline,
                    title: 'Bantuan',
                    onTap: () {
                      // TODO: Navigate to help center
                    },
                  ),
                  
                  const SizedBox(height: 40),
                  
                  // Logout Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: isLoading ? null : _handleLogout,
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
            ),
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
        leading: Icon(icon, color: Theme.of(context).primaryColor),
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}