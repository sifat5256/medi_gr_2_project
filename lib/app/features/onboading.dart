

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:http/http.dart';

import '../core/app_string.dart';
import 'Widgets/onboading_dot_navigation.dart';
import 'Widgets/onboading_next_button.dart';
import 'Widgets/onboading_page.dart';
import 'Widgets/onboading_skip.dart';
import 'icons.dart';
import 'images.dart';
import 'onboading_controller.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OnBoardingController());
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: 30,bottom: 30, left: 5,right: 5),
        child: Stack(
          children: [
            //Horizontal Scrollable Pages
            PageView(
              controller: controller.pageController,
              onPageChanged: controller.updatePageIndicator,
              children:  [
                OnBoardingPage(
                  image:  OnboardingImage.onBoardingImage1,
                  title: onBoadingTitle1,
                  subtitle: onBoadingSubTitle1
                ),
                OnBoardingPage(
                    image:  OnboardingImage.onBoardingImage2,
                    title: onBoadingTitle2,
                    subtitle: onBoadingSubTitle2
                ),
                OnBoardingPage(
                    image: OnboardingImage.onBoardingImage3,
                    title: onBoadingTitle3,
                    subtitle: onBoadingSubTitle3
                ),
              ],
            ),
            //skip Button
            const OnBoardingSkip(),
        
            //Dot Navigation SmoothPageIndicator
            const OnBoardingDotNavigation(),
        
            //Circular Button
            const OnBoardingNextButton()
          ],
        ),
      ),
    );
  }
}

