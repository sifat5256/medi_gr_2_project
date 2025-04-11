import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app/core/app_color.dart';
import 'app/features/Screen/login_screen.dart';
import 'app/features/Screen/signup_screen.dart';
import 'app/features/botttom_nav_bar/screen/profile_screen.dart';
import 'app/features/onboading.dart';


void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'EarningPoint',
      debugShowCheckedModeBanner: false,
      // getPages: [
      //   GetPage(name: '/', page: () => OnBoardingScreen()), // or your initial screen
      //   GetPage(name: '/login', page: () => LoginScreen()),
      //   GetPage(name: '/signup', page: () => SignupScreen()),
      //   GetPage(name: '/profile', page: () => ProfileScreen()),
      //   // Add other routes as needed
      // ],
      theme: ThemeData(
        primaryColor: AppColor.purpleColor,
      ),
      home:  LoginScreen(),
    );
  }
}


