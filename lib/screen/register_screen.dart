import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:flutter_firebase_app/controller/auth_controller.dart';
import 'package:flutter_firebase_app/screen/home/home.dart';

class RegisterScreen extends StatelessWidget {
  final AuthController authController = Get.find<AuthController>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(35),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Selamat Datang,',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w300),
            ),
            const Text(
              'Silahkan Daftar!',
              style: TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.bold,
                color: Color(0xff3E6B99),
              ),
            ),
            const SizedBox(height: 55),

            // Error message
            Obx(() => authController.errorMessage.value != null
                ? Container(
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.only(bottom: 15),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.red.shade200),
                    ),
                    child: Text(
                      authController.errorMessage.value!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  )
                : const SizedBox.shrink()),

            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                hintText: 'Email',
                hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(color: Color(0xff3E6B99)),
                ),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                hintText: 'Password',
                hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(width: 1, color: Color(0xff3E6B99)),
                ),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 30),

            Obx(() => SizedBox(
                  width: 200,
                  height: 43,
                  child: ElevatedButton(
                    onPressed: authController.isLoading.value
                        ? null
                        : () async {
                            await authController.registerWithEmail(
                              _emailController.text,
                              _passwordController.text,
                            );
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff3E6B99),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: authController.isLoading.value
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'Daftar',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                  ),
                )),

            TextButton(
              onPressed: () => Get.back(),
              child: const Text(
                "Sudah punya akun? Masuk",
                style: TextStyle(fontSize: 14, color: Color(0xff6A9DD7)),
              ),
            ),

            const SizedBox(height: 15),
            
            // Social Sign-up Options
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Google Sign-Up Button
                Obx(() => SizedBox(
                  width: 250,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: authController.isLoading.value
                      ? null
                      : () async {
                          await authController.signInWithGoogle();
                        },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: authController.isLoading.value
                      ? const CircularProgressIndicator()
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              'assets/google_icon.svg',
                              height: 24,
                              width: 24,
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              'Sign up with Google',
                               style: TextStyle(
                                fontSize: 14
                                ),),
                          ],
                        ),
                  ),
                )),
                
                const SizedBox(height: 15),
                
                // Facebook Sign-Up Button
                Obx(() => SizedBox(
                  width: 250,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: authController.isLoading.value
                      ? null
                      : () async {
                          await authController.signInWithFacebook();
                        },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff1877F2), // Facebook blue
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: authController.isLoading.value
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.facebook, size: 24, color: Colors.white),
                            const SizedBox(width: 5),
                            const Text('Sign up with Facebook', 
                            style: TextStyle(
                              fontSize: 14
                              )),
                          ],
                        ),
                  ),
                )),
              ],
            ),

          ],
        ),
      ),
    );
  }
}
