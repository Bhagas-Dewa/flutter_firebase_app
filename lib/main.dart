import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_app/controller/auth_controller.dart';
import 'package:get/get.dart';
import 'package:flutter_firebase_app/screen/home/home.dart';
import 'package:flutter_firebase_app/screen/login_screen.dart';
import 'package:video_player/video_player.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Get.put(AuthController());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Firebase Auth Demo',
      theme: ThemeData(
        primaryColor: Color(0xff3E6B99),
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xff3E6B99)),
        useMaterial3: true,
      ),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          
          if (snapshot.hasData) {
            return HomePage();
          }
          
          return LoginScreen();
        },
      ),
    );
  }
}