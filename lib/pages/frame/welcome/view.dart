import 'package:chatty/common/values/colors.dart';
import 'package:chatty/pages/frame/welcome/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class WelcomePage extends GetView<WelcomeController> {
  const WelcomePage({super.key});

  Widget _buildPageHeadingTitle(String title) {
    return Container(
      alignment: Alignment.center,
      child: Text(
        title,
        style:  TextStyle(
            color: AppColors.primaryElementText,
            fontFamily: "Montserrat",
            fontWeight: FontWeight.bold,
            fontSize: 45.sp),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: AppColors.primaryElement,
      body: Container(
        width: 360.w,
        height: 780.h,
        child: _buildPageHeadingTitle(controller.title),
      ),
    );
  }
}
