import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:medi_gr_2_project/app/features/Screen/login_screen.dart';
import 'package:medi_gr_2_project/app/features/botttom_nav_bar/screen/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../botttom_nav_bar/bottom_nav_bar.dart';
import '../../botttom_nav_bar/screen/profile_screen.dart';


class AuthController extends GetxController {
  static AuthController instance = Get.find();

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Rx<User?> firebaseUser = Rx<User?>(null);
  RxMap<String, dynamic> userData = RxMap<String, dynamic>({});
  // Add to AuthController
  final Rx<File?> profileImage = Rx<File?>(null);

  @override
  void onInit() {
    super.onInit();
    ever(firebaseUser, (_) => fetchProfileImage());
  }

  Future<void> fetchProfileImage() async {
    if (firebaseUser.value != null) {
      final prefs = await SharedPreferences.getInstance();
      final imagePath = prefs.getString('profile_image_path');
      if (imagePath != null && File(imagePath).existsSync()) {
        profileImage.value = File(imagePath);
      } else {
        profileImage.value = null;
      }
    }
  }

  @override
  void onReady() {
    super.onReady();
    firebaseUser.bindStream(auth.authStateChanges());
    ever(firebaseUser, _setInitialScreen);
  }

  void _setInitialScreen(User? user) {
    if (user == null) {
      Get.offAll(() => LoginScreen());

    } else {
      fetchUserData();
      Get.offAll(MainScreen());
    }
  }

  Future<void> registerUser(
      String name, String birthday, String gender, String email, String password) async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      await firestore.collection('users').doc(userCredential.user!.uid).set({
        'name': name,
        'birthday': birthday,
        'gender': gender,
        'email': email,
      });

      fetchUserData();
      Get.offAll(MainScreen());
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  Future<void> loginUser(String email, String password) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      fetchUserData();
      Get.offAll(MainScreen());
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'invalid-email':
          errorMessage = 'The email address is badly formatted.';
          break;
        case 'user-disabled':
          errorMessage = 'This user has been disabled.';
          break;
        case 'user-not-found':
          errorMessage = 'No user found with this email.';
          break;
        case 'wrong-password':
          errorMessage = 'Incorrect password.';
          break;
        default:
          errorMessage = 'Login failed. Please try again.';
      }
      Get.snackbar("Error", errorMessage);
    } catch (e) {
      Get.snackbar("Error", "An unexpected error occurred");
    }
  }

  void logout() async {
    await auth.signOut();
    Get.offAll(() => LoginScreen());


  }

  void fetchUserData() async {
    if (firebaseUser.value != null) {
      DocumentSnapshot userDoc =
      await firestore.collection('users').doc(firebaseUser.value!.uid).get();
      userData.value = userDoc.data() as Map<String, dynamic>;
    }
  }
}
