
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../core/app_color.dart';
import '../onboading_controller.dart';

class OnBoardingDotNavigation extends StatelessWidget {
  const OnBoardingDotNavigation({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = OnBoardingController.instance;

    return Positioned(
        bottom: 10,
        left:10,
        child: SmoothPageIndicator(
          controller: controller.pageController,
          onDotClicked:controller.dotNavigationClick,
          count: 3,

          effect:   ExpandingDotsEffect(
            dotColor: AppColor.greyColor,
              activeDotColor:AppColor.purpleColor, dotHeight: 6),
        )
    );
  }
}
