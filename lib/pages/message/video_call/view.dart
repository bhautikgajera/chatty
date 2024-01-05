import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:chatty/common/values/colors.dart';
import 'package:chatty/pages/message/voice_call/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'controller.dart';

class VideoCallPage extends GetView<VideoCallController> {
  const VideoCallPage({super.key});

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
          print(
              "OBX =>>>>  remote Id =>>> ${controller.state.onRemoteUID.value}");
          if (!controller.state.isReadyPreview.value) {
            return const SizedBox();
          }
          return Stack(
            fit: StackFit.expand,
            children: [
              if (controller.state.onRemoteUID.value != 0)
                AgoraVideoView(
                  controller: VideoViewController.remote(
                    rtcEngine: controller.engine,
                    canvas: VideoCanvas(
                      uid: controller.state.onRemoteUID.value,
                    ),
                    connection: RtcConnection(
                      channelId: controller.state.channelId.value,
                    ),
                  ),
                ),
              Positioned(
                bottom: 80.h,
                left: 30.w,
                right: 30.w,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
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
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30.w),
                              color: controller.state.isJoin.value
                                  ? AppColors.primaryElementBg
                                  : AppColors.primaryElementStatus,
                            ),
                            child: controller.state.isJoin.value
                                ? Image.asset('assets/icons/a_phone.png')
                                : Image.asset("assets/icons/a_telephone.png"),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          controller.state.isJoin.value
                              ? "Disconnect"
                              : "Connecting",
                          style: TextStyle(
                            color: AppColors.primaryElementText,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              if (controller.state.isShowAvatar.isFalse)
                Positioned(
                    top: 10,
                    right: 30,
                    left: 30,
                    child: Column(
                      children: [
                        Text(
                          controller.state.callTime.value,
                          style: const TextStyle(
                              color: AppColors.primaryElementText),
                        ),
                      ],
                    )),

              // if user did not join, show his avatar
              if (controller.state.isShowAvatar.value)
                Positioned(
                    child: Column(
                  children: [
                    // show user avatar
                    Container(
                      width: 70.w,
                      height: 70.w,
                      margin: EdgeInsets.only(top: 150.h),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.w),
                        color: AppColors.primaryElementText,
                      ),
                      child: Image.network(
                        controller.state.toAvatar.value,
                        fit: BoxFit.fill,
                      ),
                    ),
                    // show other user's name
                    Container(
                      margin: EdgeInsets.only(top: 6.h),
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
            ],
          );
        }),
      ),
    );
  }
}
