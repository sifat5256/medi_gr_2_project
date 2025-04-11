
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'Screen/login_screen.dart';

class OnBoardingController extends GetxController{
  static OnBoardingController get instance => Get.find();

  //variable

  final pageController = PageController();
  Rx<int> currentPageIndex = 0.obs;

  //update page indicator
  void updatePageIndicator(index)=>currentPageIndex.value = index;

  //Navigation Click
  void dotNavigationClick(index){
    currentPageIndex.value = index;
    pageController.jumpTo(index);
  }

  //Next Page
  void nextPage(){
    if(currentPageIndex.value == 2){
      Get.offAll(LoginScreen());
    }else{
      int page = currentPageIndex.value + 1;
      pageController.jumpToPage(page);
    }
  }

  //Skip Page
  void skipPage(){
    currentPageIndex.value = 2;
    pageController.jumpToPage(2);
  }
}