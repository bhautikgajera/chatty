import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatty/common/entities/message.dart';
import 'package:chatty/common/routes/names.dart';
import 'package:chatty/common/style/color.dart';
import 'package:chatty/common/utils/utils.dart';
import 'package:chatty/common/values/colors.dart';
import 'package:chatty/pages/frame/welcome/index.dart';
import 'package:chatty/pages/message/controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class MessagePage extends GetView<MessageController> {
  const MessagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => SafeArea(
              child: Stack(
            children: [
              CustomScrollView(
                slivers: [
                  SliverAppBar(
                    pinned: true,
                    title: _headBar(),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 0,
                      vertical: 0,
                    ),
                    sliver: SliverToBoxAdapter(
                      child: _headTabs(),
                    ),
                  ),
                  SliverPadding(
                    padding:
                        EdgeInsets.symmetric(vertical: 0, horizontal: 20.w),
                    sliver: controller.state.tabStatus.value
                        ? SliverList(
                            delegate:
                                SliverChildBuilderDelegate((context, index) {
                              var item = controller.state.msgList[index];
                              return chatListItem(item);
                            }, childCount: controller.state.msgList.length),
                          )
                        : const SliverToBoxAdapter(
                            child: SizedBox(),
                          ),
                  ),
                ],
              ),
              Positioned(
                bottom: 70.w,
                right: 20.w,
                height: 50.w,
                child: GestureDetector(
                  onTap: () {
                    Get.toNamed(AppRoutes.Contact);
                  },
                  child: Container(
                    height: 50.w,
                    width: 50.w,
                    padding: EdgeInsets.all(10.w),
                    decoration: BoxDecoration(
                        color: AppColors.primaryElement,
                        borderRadius: BorderRadius.circular(25.w),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 2,
                            offset: const Offset(1, 1),
                          )
                        ]),
                    child: Image.asset('assets/icons/contact.png'),
                  ),
                ),
              ),
            ],
          ))),
    );
  }

  // Head Bar >>>>>>>>>>>>>>
  Widget _headBar() {
    return Center(
      child: Container(
        width: 320.w,
        height: 44.h,
        margin: EdgeInsets.symmetric(vertical: 20.h),
        child: Row(
          children: [
            Stack(
              children: [
                GestureDetector(
                  onTap: () {
                    controller.goProfile();
                  },
                  child: Container(
                    height: 44.h,
                    width: 44.h,
                    decoration: BoxDecoration(
                        color: AppColors.primarySecondaryBackground,
                        borderRadius: BorderRadius.circular(22.h),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 10,
                              blurRadius: 20,
                              offset: const Offset(0, 1)),
                        ]),
                    child: controller.state.headDetail.value.avatar == null
                        ? const Image(
                            image:
                                AssetImage("assets/images/account_header.png"))
                        : CachedNetworkImage(
                            imageUrl: controller.state.headDetail.value.avatar!,
                            errorWidget: (context, url, error) {
                              return const Image(
                                  image: AssetImage(
                                      "assets/images/account_header.png"));
                            },
                            imageBuilder: (context, imageProvider) {
                              return Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(22.w),
                                  image: DecorationImage(image: imageProvider),
                                ),
                              );
                            },
                          ),
                  ),
                ),
                Positioned(
                  bottom: 5.w,
                  right: 0,
                  height: 14.w,
                  child: Container(
                    height: 14.w,
                    width: 14.w,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7.w),
                        border: Border.all(
                          width: 2.w,
                          color: AppColors.primaryElementText,
                        ),
                        color: AppColors.primaryElementStatus),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _headTabs() {
    return Container(
      height: 48.h,
      width: 320.w,
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
          color: AppColors.primarySecondaryBackground,
          borderRadius: BorderRadius.circular(5)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              controller.goTabStatus();
            },
            child: Container(
              width: 150,
              height: 40.h,
              alignment: Alignment.center,
              decoration: controller.state.tabStatus.value
                  ? BoxDecoration(
                      color: AppColors.primaryBackground,
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 3,
                            offset: const Offset(0, 2),
                          ),
                        ])
                  : const BoxDecoration(),
              child: const Text("Chat"),
            ),
          ),
          GestureDetector(
            onTap: () {
              controller.goTabStatus();
            },
            child: Container(
              width: 150,
              height: 40.h,
              alignment: Alignment.center,
              decoration: controller.state.tabStatus.value
                  ? const BoxDecoration()
                  : BoxDecoration(
                      color: AppColors.primaryBackground,
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 3,
                            offset: const Offset(0, 2),
                          ),
                        ]),
              child: const Text("Call"),
            ),
          ),
        ],
      ),
    );
  }

  Widget chatListItem(Message item) {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        child: InkWell(
            onTap: () {
              if (item.doc_id != null) {
                Get.toNamed("/chat", parameters: {
                  "doc_id": item.doc_id!,
                  "to_token": item.token!,
                  "to_name": item.name!,
                  "to_avatar": item.avatar!,
                  "to_online": item.online.toString(),
                });
              }
            },
            child: Row(
              children: [
                // Profile Image
                Container(
                  height: 44.h,
                  width: 44.h,
                  margin: const EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                      color: AppColors.primarySecondaryBackground,
                      borderRadius: BorderRadius.circular(22.h),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 10,
                            blurRadius: 20,
                            offset: const Offset(0, 1)),
                      ]),
                  child: item.avatar == null
                      ? const Image(
                          image: AssetImage("assets/images/account_header.png"))
                      : CachedNetworkImage(
                          imageUrl: item.avatar!,
                          errorWidget: (context, url, error) {
                            return const Image(
                                image: AssetImage(
                                    "assets/images/account_header.png"));
                          },
                          imageBuilder: (context, imageProvider) {
                            return Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(22.w),
                                image: DecorationImage(image: imageProvider),
                              ),
                            );
                          },
                        ),
                ),
                Container(
                  child: Row(
                    children: [
                      SizedBox(
                        height: 44.w,
                        width: 175.w,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.name ?? "-",
                              overflow: TextOverflow.clip,
                              maxLines: 1,
                              softWrap: false,
                              style: TextStyle(
                                fontFamily: "Avenir",
                                fontWeight: FontWeight.bold,
                                fontSize: 14.sp,
                                color: AppColors.thirdElement,
                              ),
                            ),
                            Text(
                              "${item.last_msg}",
                              style: TextStyle(
                                fontFamily: "Avenir",
                                fontWeight: FontWeight.normal,
                                fontSize: 12.sp,
                                color: AppColors.thirdElement,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 86.w,
                        height: 44.w,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            if (item.last_time != null)
                              Text(
                                duTimeLineFormat(
                                    (item.last_time as Timestamp).toDate()),
                                style: TextStyle(
                                  fontFamily: "Avenir",
                                  color: AppColors.primaryElementText,
                                  fontSize: 11.sp,
                                ),
                              ),
                            if (item.msg_num != 0)
                              Container(
                                padding:
                                    const EdgeInsets.only(left: 4, right: 4),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  item.msg_num.toString(),
                                  maxLines: 1,
                                  style: TextStyle(
                                    fontFamily: "Avenir",
                                    color: AppColors.primaryElementText,
                                    fontSize: 11.sp,
                                  ),
                                ),
                              )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )));
  }
}
