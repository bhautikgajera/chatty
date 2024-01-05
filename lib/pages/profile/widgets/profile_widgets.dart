import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatty/common/values/values.dart';
import 'package:chatty/pages/profile/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

AppBar buildAppBar() {
  return AppBar(
    title: Text(
      "Profile",
      style: TextStyle(
        color: AppColors.primaryText,
        fontSize: 16.sp,
      ),
    ),
  );
}

Widget buildProfilePhoto(ProfileController controller) {
  return Stack(
    children: [
      Container(
        height: 120.w,
        width: 120.w,
        decoration: BoxDecoration(
            color: AppColors.primarySecondaryBackground,
            borderRadius: BorderRadius.circular(60.w),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 2,
                blurRadius: 3,
                offset: const Offset(0, 2),
              )
            ]),
        child: controller.state.profileDetail.value.avatar == null
            ? const Image(image: AssetImage("assets/images/account_header.png"))
            : CachedNetworkImage(
                imageUrl: controller.state.profileDetail.value.avatar!,
                errorWidget: (context, url, error) {
                  return const Image(
                      image: AssetImage("assets/images/account_header.png"));
                },
                imageBuilder: (context, imageProvider) {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(60.w),
                      image: DecorationImage(image: imageProvider),
                    ),
                  );
                },
              ),
      ),
      Positioned(
        bottom: 10,
        right: 5,
        height: 35.w,
        child: GestureDetector(
          child: Container(
            height: 35.w,
            width: 35.w,
            decoration: BoxDecoration(
              color: AppColors.primaryElement,
              borderRadius: BorderRadius.circular(18.w),
            ),
            child: Image.asset("assets/icons/edit.png"),
          ),
        ),
      ),
    ],
  );
}

Widget buildCompleteBtn() {
  return GestureDetector(
    child: Container(
      width: 295.w,
      height: 44.h,
      decoration: BoxDecoration(
          color: AppColors.primaryElement,
          borderRadius: BorderRadius.circular(5.w),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 3,
              offset: const Offset(0, 2),
            )
          ]),
      alignment: Alignment.center,
      child: Text(
        "Complete",
        style: TextStyle(
          color: AppColors.primaryElementText,
          fontSize: 14.sp,
        ),
      ),
    ),
  );
}

Widget buildLogOutBtn(ProfileController controller) {
  return GestureDetector(
    onTap: () {
      Get.defaultDialog(
          title: "Are You Sure To LogOut!",
          content: const SizedBox(),
          onConfirm: () {
            controller.goLogout();
          },
          onCancel: () {});
    },
    child: Container(
      width: 295.w,
      height: 44.h,
      margin: EdgeInsets.only(
        top: 60.h,
      ),
      decoration: BoxDecoration(
          color: AppColors.primarySecondaryElementText,
          borderRadius: BorderRadius.circular(5.w),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 3,
              offset: const Offset(0, 2),
            )
          ]),
      alignment: Alignment.center,
      child: Text(
        "Logout",
        style: TextStyle(
          color: AppColors.primaryElementText,
          fontSize: 14.sp,
        ),
      ),
    ),
  );
}
