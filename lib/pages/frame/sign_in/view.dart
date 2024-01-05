import 'package:chatty/common/values/colors.dart';
import 'package:chatty/pages/frame/sign_in/controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SignInPage extends GetView<SignInController> {
  const SignInPage({super.key});

  Widget _buildLogo() {
    return Container(
      margin: EdgeInsets.only(top: 100.h, bottom: 80.h),
      child: Text(
        "Chatty .",
        textAlign: TextAlign.center,
        style: TextStyle(
          color: AppColors.primaryText,
          fontWeight: FontWeight.bold,
          fontSize: 34.sp,
        ),
      ),
    );
  }

  Widget _buildThirdPartyLogin(String loginType) {
    return GestureDetector(
      onTap: () {
        controller.handleSignIn(loginType);
      },
      child: Container(
        width: 295.w,
        height: 44.h,
        padding: EdgeInsets.all(10.h),
        margin: EdgeInsets.only(bottom: 15.h),
        decoration:
            BoxDecoration(color: AppColors.primaryBackground, boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 2,
              spreadRadius: 1,
              offset: const Offset(0, 2)),
        ]),
        child: Row(
          children: [
            loginType == "phone number"
                ? const Spacer()
                : Container(
                    margin: EdgeInsets.only(left: 40.w, right: 30.w),
                    child: Image.asset(
                        "assets/icons/${loginType.toLowerCase()}.png"),
                  ),
            Container(
              child: Text(
                "Sign in with $loginType",
                style: TextStyle(
                  color: AppColors.primaryText,
                  fontWeight: FontWeight.bold,
                  fontSize: 10.sp,
                ),
              ),
            ),
            if (loginType == "phone number") const Spacer(),
          ],
        ),
      ),
    );
  }

  Widget _buildOrWidget() {
    return Container(
      child: const Row(
        children: [
          Expanded(
              child: Divider(
            indent: 50,
          )),
          Text("  or  "),
          Expanded(
              child: Divider(
            endIndent: 50,
          )),
        ],
      ),
    );
  }

  GestureDetector _buildSignUpWidget() {
    return GestureDetector(
      child: Column(
        children: [
          Text(
            "Already have an account",
            style: TextStyle(
              color: AppColors.primaryText,
              fontWeight: FontWeight.normal,
              fontSize: 12.sp,
            ),
          ),
          Text(
            "Sign up here",
            style: TextStyle(
              color: AppColors.primaryElement,
              fontWeight: FontWeight.normal,
              fontSize: 12.sp,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primarySecondaryBackground,
      body: Center(
        child: Column(
          children: [
            _buildLogo(),
            _buildThirdPartyLogin("Google"),
            _buildThirdPartyLogin("Facebook"),
            _buildThirdPartyLogin("Apple"),
            _buildOrWidget(),
            _buildThirdPartyLogin("phone number"),
            _buildSignUpWidget(),
          ],
        ),
      ),
    );
  }
}
