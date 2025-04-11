import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app/core/app_color.dart';
import 'app/features/onboading.dart';


void main() {
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
      theme: ThemeData(
        primaryColor: AppColor.purpleColor,
      ),
      home:  OnBoardingScreen(),
    );
  }
}


