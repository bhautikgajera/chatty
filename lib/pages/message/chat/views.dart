import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatty/common/values/values.dart';
import 'package:chatty/pages/message/chat/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'widgets/chat_list.dart';

class ChatPage extends GetView<ChatController> {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppbar(),
      body: SafeArea(
        child: Stack(
          children: [
            const ChatList(),
            Positioned(
              bottom: 0,
              child: Container(
                width: 360.w,
                padding: EdgeInsets.only(left: 20.w, bottom: 10.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 270.w,
                      padding: EdgeInsets.only(
                        top: 10.h,
                        bottom: 10.h,
                      ),
                      decoration: BoxDecoration(
                          color: AppColors.primaryBackground,
                          border: Border.all(
                            color: AppColors.primarySecondaryElementText,
                          ),
                          borderRadius: BorderRadius.circular(5.w)),
                      child: Row(
                        children: [
                          // TextField Container and send messages >>>>
                          Container(
                            width: 220.w,
                            child: TextField(
                              controller: controller.myInputController,
                              maxLines: null,
                              keyboardType: TextInputType.multiline,
                              decoration: InputDecoration(
                                hintText: "Message....",
                                contentPadding: EdgeInsets.only(
                                  left: 15.w,
                                ),
                                border: const OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                ),
                                enabledBorder: const OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                ),
                                disabledBorder: const OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                ),
                                focusedBorder: const OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                ),
                              ),
                              autofocus: false,
                            ),
                          ),
                          // Send Button
                          GestureDetector(
                            onTap: () {
                              // this method will call when hit tha send button
                              controller.sendMessage();
                            },
                            child: Container(
                              width: 40.w,
                              height: 40.w,
                              child: Image.asset('assets/icons/send.png'),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Plus Button
                    GestureDetector(
                      onTap: () {
                        controller.goMore();
                      },
                      child: Container(
                        height: 40.w,
                        width: 40.w,
                        padding: EdgeInsets.all(8.w),
                        margin: EdgeInsets.only(right: 20.w),
                        decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(
                              20.w,
                            ),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  spreadRadius: 2,
                                  blurRadius: 2,
                                  offset: const Offset(1, 1))
                            ]),
                        child: Image.asset("assets/icons/add.png"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              height: 200.h,
              right: 20.w,
              bottom: 70.h,
              width: 40.w,
              child: StreamBuilder(
                stream: controller.state.moreState.stream,
                builder: (context, snapshot) {
                  if (!snapshot.hasData ||
                      snapshot.data == null ||
                      snapshot.data == false) {
                    return const SizedBox();
                  }

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        child: Container(
                          height: 40.h,
                          width: 40.h,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: AppColors.primaryBackground,
                              boxShadow: [
                                BoxShadow(
                                  spreadRadius: 2,
                                  blurRadius: 2,
                                  offset: const Offset(1, 1),
                                  color: Colors.grey.withOpacity(
                                    0.2,
                                  ),
                                )
                              ],
                              borderRadius: BorderRadius.circular(20.h)),
                          child: Image.asset('assets/icons/file.png'),
                        ),
                      ),
                      // image Button
                      GestureDetector(
                        onTap: () {
                          controller.imgFromGallery();
                        },
                        child: Container(
                          height: 40.h,
                          width: 40.h,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: AppColors.primaryBackground,
                              boxShadow: [
                                BoxShadow(
                                  spreadRadius: 2,
                                  blurRadius: 2,
                                  offset: const Offset(1, 1),
                                  color: Colors.grey.withOpacity(
                                    0.2,
                                  ),
                                )
                              ],
                              borderRadius: BorderRadius.circular(20.h)),
                          child: Image.asset('assets/icons/photo.png'),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          controller.voiceCall();
                        },
                        child: Container(
                          height: 40.h,
                          width: 40.h,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: AppColors.primaryBackground,
                              boxShadow: [
                                BoxShadow(
                                  spreadRadius: 2,
                                  blurRadius: 2,
                                  offset: const Offset(1, 1),
                                  color: Colors.grey.withOpacity(
                                    0.2,
                                  ),
                                )
                              ],
                              borderRadius: BorderRadius.circular(20.h)),
                          child: Image.asset('assets/icons/call.png'),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          controller.videoCall();
                        },
                        child: Container(
                          height: 40.h,
                          width: 40.h,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: AppColors.primaryBackground,
                              boxShadow: [
                                BoxShadow(
                                  spreadRadius: 2,
                                  blurRadius: 2,
                                  offset: const Offset(1, 1),
                                  color: Colors.grey.withOpacity(
                                    0.2,
                                  ),
                                )
                              ],
                              borderRadius: BorderRadius.circular(20.h)),
                          child: Image.asset('assets/icons/video.png'),
                        ),
                      )
                    ],
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  AppBar _buildAppbar() {
    return AppBar(
      title: Obx(
        () => Container(
          child: Text(
            controller.state.to_name.value,
            overflow: TextOverflow.clip,
            maxLines: 1,
            style: TextStyle(
              fontFamily: 'Avenir',
              fontWeight: FontWeight.bold,
              color: AppColors.primaryText,
              fontSize: 16.sp,
            ),
          ),
        ),
      ),
      actions: [
        Padding(
          padding: EdgeInsets.only(right: 20.w),
          child: Stack(
            children: [
              Container(
                width: 44.w,
                height: 44.h,
                child: CachedNetworkImage(
                  imageUrl: controller.state.to_avatar.value,
                  imageBuilder: (context, imageProvider) {
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(22.w),
                        image: DecorationImage(image: imageProvider),
                      ),
                    );
                  },
                  errorWidget: (context, url, error) {
                    return Image.asset('assets/images/account_header.png');
                  },
                ),
              ),
              Positioned(
                  bottom: 5.w,
                  right: 0,
                  child: Container(
                    width: 14.w,
                    height: 14.w,
                    decoration: BoxDecoration(
                      border: Border.all(
                          width: 2, color: AppColors.primaryElementText),
                      color: controller.state.to_online.value == "1"
                          ? AppColors.primaryElementStatus
                          : AppColors.primarySecondaryElementText,
                    ),
                  )),
            ],
          ),
        ),
      ],
    );
  }
}
