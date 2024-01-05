import 'package:chatty/common/values/colors.dart';
import 'package:chatty/pages/message/voice_call/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class VoiceCallPage extends GetView<VoiceCallController> {
  const VoiceCallPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary_bg,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          controller.engine.leaveChannel();
        },
        child: Text(controller.title),
      ),
      body: SafeArea(
        child: Obx(() {
          return Container(
            child: Stack(
              children: [
                Positioned(
                    top: 10.h,
                    left: 30.w,
                    right: 30.w,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          controller.state.callTime.value,
                          style: TextStyle(
                            color: AppColors.primaryElementText,
                            fontSize: 40.sp,
                          ),
                        ),
                        Container(
                          height: 70.h,
                          width: 70.h,
                          margin: EdgeInsets.only(top: 150.h),
                          child: Image.network(
                            controller.state.toAvatar.value,
                            height: 70.h,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                            top: 5.h,
                          ),
                          child: Text(
                            controller.state.toName.value,
                            style: TextStyle(
                              color: AppColors.primaryElementText,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                      ],
                    )),
                Positioned(
                  bottom: 80.h,
                  left: 30.h,
                  right: 30.w,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // Microphone Section
                      Column(
                        children: [
                          GestureDetector(
                            onTap: () {},
                            child: Container(
                              height: 60.w,
                              width: 60.w,
                              padding: EdgeInsets.all(15.w),
                              decoration: BoxDecoration(
                                color: controller.state.openMicrophone.value
                                    ? AppColors.primaryElementText
                                    : AppColors.primaryText,
                                borderRadius: BorderRadius.circular(30.w),
                              ),
                              child: Image.asset(
                                  'assets/icons/${controller.state.openMicrophone.value ? "b" : "a"}_microphone.png'),
                            ),
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          Text(
                            "MicroPhone",
                            style: TextStyle(
                              color: AppColors.primaryElementText,
                              fontSize: 12.sp,
                            ),
                          ),
                        ],
                      ),
                      // Is Joined
                      Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              if (controller.state.isJoin.value) {
                                controller.leaveChannel();
                              } else {
                                controller.joinChannel();
                              }
                            },
                            child: Container(
                              height: 60.w,
                              width: 60.w,
                              padding: EdgeInsets.all(15.w),
                              decoration: BoxDecoration(
                                color: controller.state.isJoin.value
                                    ? AppColors.primaryElementBg
                                    : AppColors.primaryElementStatus,
                                borderRadius: BorderRadius.circular(30.w),
                              ),
                              child: Image.asset(
                                  'assets/icons/${controller.state.isJoin.value ? "a_" : "a_tele"}phone.png'),
                            ),
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          Text(
                            controller.state.isJoin.value
                                ? "Disconnect"
                                : "Connect",
                            style: TextStyle(
                              color: AppColors.primaryElementText,
                              fontSize: 12.sp,
                            ),
                          ),
                        ],
                      ),
                      // Speaker
                      Column(
                        children: [
                          GestureDetector(
                            onTap: () {},
                            child: Container(
                              height: 60.w,
                              width: 60.w,
                              padding: EdgeInsets.all(15.w),
                              decoration: BoxDecoration(
                                color: controller.state.enableSpeaker.value
                                    ? AppColors.primaryElementText
                                    : AppColors.primaryText,
                                borderRadius: BorderRadius.circular(30.w),
                              ),
                              child: Image.asset(
                                  'assets/icons/${controller.state.enableSpeaker.value ? "b" : "a"}_trumpet.png'),
                            ),
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          Text(
                            "Speaker",
                            style: TextStyle(
                              color: AppColors.primaryElementText,
                              fontSize: 12.sp,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        }),
      ),
    );
  }
}
