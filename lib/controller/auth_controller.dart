import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:flutter_firebase_app/service/auth_service.dart';
import 'package:flutter_firebase_app/models/user_model.dart';
import 'package:flutter_firebase_app/screen/home/home.dart';
import 'package:flutter_firebase_app/screen/login_screen.dart';

class AuthController extends GetxController {
  final AuthService _authService = AuthService();

  // Observables (state yang bisa berubah)
  var isLoading = false.obs;
  var errorMessage = RxnString();
  var currentUser = Rxn<UserModel>();

  @override
  void onInit() {
    super.onInit();
    fetchCurrentUser(); // Ambil user saat aplikasi dimulai
  }

  // Login dengan email & password
  Future<void> loginWithEmail(String email, String password) async {
    try {
      isLoading.value = true;
      errorMessage.value = null;

      await _authService.signInWithEmailAndPassword(email, password);
      await fetchCurrentUser();

      Get.offAll(() => HomePage()); // Navigasi ke Home setelah login
    } on FirebaseAuthException catch (e) {
      _handleAuthError(e);
    } catch (e) {
      errorMessage.value = "Terjadi kesalahan: ${e.toString()}";
    } finally {
      isLoading.value = false;
    }
  }

  // Register dengan email & password
  Future<void> registerWithEmail(String email, String password) async {
    try {
      isLoading.value = true;
      errorMessage.value = null;

      await _authService.registerWithEmailAndPassword(email, password);
      await fetchCurrentUser();

      Get.offAll(() => HomePage()); // Navigasi ke Home setelah register
    } on FirebaseAuthException catch (e) {
      _handleAuthError(e);
    } catch (e) {
      errorMessage.value = "Terjadi kesalahan: ${e.toString()}";
    } finally {
      isLoading.value = false;
    }
  }

  // Login dengan Google
  Future<void> signInWithGoogle() async {
    try {
      isLoading.value = true;
      errorMessage.value = null;

      final userCredential = await _authService.signInWithGoogle();
      if (userCredential != null) {
        await fetchCurrentUser();
        Get.offAll(() => HomePage()); // Navigasi ke Home
      }
    } catch (e) {
      errorMessage.value = "Gagal login dengan Google: ${e.toString()}";
    } finally {
      isLoading.value = false;
    }
  }

  // Logout
  Future<void> logout() async {
  try {
    isLoading.value = true;
    errorMessage.value = null;

    await _authService.signOut();
    currentUser.value = null;

    // Navigasi ke halaman login setelah logout
    Get.offAll(() => LoginScreen()); 
  } catch (e) {
    errorMessage.value = "Gagal logout: ${e.toString()}";
  } finally {
    isLoading.value = false;
  }
}


  // Fetch data user dari Firestore
  Future<void> fetchCurrentUser() async {
    UserModel? user = await _authService.getUserData();
    currentUser.value = user;
  }

  // Handle error FirebaseAuth
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
}
