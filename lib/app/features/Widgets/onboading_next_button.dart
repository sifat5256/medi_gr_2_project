
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../core/app_color.dart';
import '../onboading_controller.dart';

class OnBoardingNextButton extends StatelessWidget {
  const OnBoardingNextButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    return Positioned(
        right: 10,
        bottom: 10,
        child: ElevatedButton(
          onPressed: ()=> OnBoardingController.instance.nextPage(),
          style: ElevatedButton.styleFrom(shape: const CircleBorder(),backgroundColor: AppColor.purpleColor),
          child: Icon(Icons.arrow_forward_ios,color: AppColor.greyColor,),
        ));
  }
}