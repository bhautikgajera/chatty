import 'package:chatty/common/values/colors.dart';
import 'package:chatty/pages/message/chat/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'chat_left_list.dart';
import 'chat_right_list.dart';

class ChatList extends GetView<ChatController> {
  const ChatList({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => GestureDetector(
        onTap: () {
          controller.closeAllPops();
        },
        child: Container(
          color: AppColors.primaryBackground,
          padding: EdgeInsets.only(bottom: 70.h),
          child: CustomScrollView(
            controller: controller.myScrollController,
            reverse: true,
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                  var item = controller.state.msgContentList[index];
                  if (item.token == controller.token) {
                    // item token is equal to token then this is a sender
                    return ChatRightList(
                      item: item,
                    );
                  } else {
                    return ChatLeftList(item: item);
                  }
                }, childCount: controller.state.msgContentList.length)),
              ),
              if (controller.state.isLoading.value)
                const SliverToBoxAdapter(
                  child: Align(
                      alignment: Alignment.center,
                      child: Text("Loading......")),
                )
            ],
          ),
        ),
      ),
    );
  }
}
