import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_firebase_app/models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Stream untuk memantau perubahan status autentikasi
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Register dengan email dan password 
  Future<UserCredential> registerWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      // Buat dokumen user di Firestore
      await _createUserDocument(userCredential.user!);
      
      return userCredential;
    } catch (e) {
      rethrow;
    }
  }

  // Login dengan email dan password
  Future<UserCredential> signInWithEmailAndPassword(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      rethrow;
    }
  }

  // Login dengan Google
  Future<UserCredential?> signInWithGoogle() async {
  try {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    if (googleUser == null) return null;

    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final OAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    UserCredential userCredential = await _auth.signInWithCredential(credential);
    await _createUserDocument(userCredential.user!);
    
    return userCredential;
  } catch (e) {
    print('Google Sign-In Error: $e');
    rethrow;
  }
}


  // Logout
  Future<void> signOut() async {
    try {
      // Sign out from Firebase
      await _auth.signOut();
      
      // Sign out from Google if the user was signed in with Google
      await _googleSignIn.signOut();
    } catch (e) {
      print('Sign Out Error: $e');
      rethrow;
    }
  }

  // Buat dokumen user di Firestore
  Future<void> _createUserDocument(User user) async {
  DocumentSnapshot doc = await _firestore.collection('users').doc(user.uid).get();
  
  if (!doc.exists) {
    UserModel newUser = UserModel(
      id: user.uid,
      email: user.email ?? '',
      name: user.displayName ?? '', 
      createdAt: DateTime.now(), // Menyimpan waktu pembuatan akun
    );
    
    await _firestore.collection('users').doc(user.uid).set(newUser.toMap());
  }
}


  // Dapatkan data user dari Firestore
  Future<UserModel?> getUserData() async {
    if (currentUser == null) return null;
    
    DocumentSnapshot doc = await _firestore.collection('users').doc(currentUser!.uid).get();
    
    if (doc.exists) {
      return UserModel.fromMap(doc.data() as Map<String, dynamic>);
    }
    
    return null;
  }

  // Update user data
  Future<void> updateUserData(Map<String, dynamic> data) async {
    if (currentUser == null) return;
    
    await _firestore.collection('users').doc(currentUser!.uid).update(data);
  }
}