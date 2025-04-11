
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../core/app_color.dart';
import '../onboading_controller.dart';

class OnBoardingSkip extends StatelessWidget {
  const OnBoardingSkip({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
        top: 20,
        right: 10,
        child: TextButton(
          onPressed: () => OnBoardingController.instance.skipPage(),
          child: Text("Skip",style: TextStyle(
            fontSize: 20,
            color: AppColor.purpleColor,
            fontWeight: FontWeight.bold
          ),),
        ));
  }
}