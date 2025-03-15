import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_app/service/auth_service.dart';
import 'package:flutter_firebase_app/models/user_model.dart';

class AuthController {
  final AuthService _authService = AuthService();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Status loading
  ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);
  
  // Pesan error
  ValueNotifier<String?> errorMessage = ValueNotifier<String?>(null);

  // Register
  Future<bool> register(BuildContext context) async {
    try {
      isLoading.value = true;
      errorMessage.value = null;
      
      await _authService.registerWithEmailAndPassword(
        emailController.text.trim(),
        passwordController.text.trim(),
      );
      
      return true;
    } on FirebaseAuthException catch (e) {
      _handleAuthError(e);
      return false;
    } catch (e) {
      errorMessage.value = "Terjadi kesalahan: ${e.toString()}";
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Login
  Future<bool> login(BuildContext context) async {
    try {
      isLoading.value = true;
      errorMessage.value = null;
      
      await _authService.signInWithEmailAndPassword(
        emailController.text.trim(),
        passwordController.text.trim(),
      );
      
      return true;
    } on FirebaseAuthException catch (e) {
      _handleAuthError(e);
      return false;
    } catch (e) {
      errorMessage.value = "Terjadi kesalahan: ${e.toString()}";
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Login dengan Google
  Future<bool> signInWithGoogle(BuildContext context) async {
    try {
      isLoading.value = true;
      errorMessage.value = null;
      
      final userCredential = await _authService.signInWithGoogle();
      
      return userCredential != null;
    } catch (e) {
      errorMessage.value = "Gagal login dengan Google: ${e.toString()}";
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Logout - Updated with proper error handling and loading state
  Future<bool> logout(BuildContext context) async {
    try {
      isLoading.value = true;
      errorMessage.value = null;
      
      await _authService.signOut();
      
      return true;
    } on FirebaseAuthException catch (e) {
      _handleAuthError(e);
      return false;
    } catch (e) {
      errorMessage.value = "Gagal logout: ${e.toString()}";
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Handle Firebase Auth error
  void _handleAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        errorMessage.value = "Akun tidak ditemukan";
        break;
      case 'wrong-password':
        errorMessage.value = "Password salah";
        break;
      case 'email-already-in-use':
        errorMessage.value = "Email sudah digunakan";
        break;
      case 'weak-password':
        errorMessage.value = "Password terlalu lemah";
        break;
      case 'invalid-email':
        errorMessage.value = "Format email tidak valid";
        break;
      default:
        errorMessage.value = "Error: ${e.message}";
    }
  }

  // Get current user data
  Future<UserModel?> getCurrentUser() async {
    return await _authService.getUserData();
  }

  // Cek status autentikasi
  Stream<User?> get authStateChanges => _authService.authStateChanges;

  // Dispose controllers
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    isLoading.dispose();
    errorMessage.dispose();
  }
}