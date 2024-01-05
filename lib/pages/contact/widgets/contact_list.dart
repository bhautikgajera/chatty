import 'package:chatty/common/entities/contact.dart';
import 'package:chatty/common/values/colors.dart';
import 'package:chatty/pages/contact/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ContactList extends GetView<ContactController> {
  const ContactList({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return CustomScrollView(
        slivers: [
          SliverPadding(
            padding: EdgeInsets.symmetric(vertical: 0.w, horizontal: 20.w),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                var item = controller.state.contactList[index];
                print(item.name);
                return _buildListItem(item);
              }, childCount: controller.state.contactList.length),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildListItem(ContactItem item) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: const BoxDecoration(
        border: Border(
          bottom:
              BorderSide(width: 2, color: AppColors.primarySecondaryBackground),
        ),
      ),
      child: InkWell(
        onTap: () {
          controller.goChat(item);
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 44.w,
              height: 44.w,
              decoration: const BoxDecoration(
                  color: AppColors.primarySecondaryBackground, boxShadow: []),
              child: CachedNetworkImage(
                imageUrl: item.avatar!,
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
            SizedBox(
              width: 10.w,
            ),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: SizedBox(
                      width: 200.w,
                      child: Text(
                        item.name ?? "-",
                        overflow: TextOverflow.clip,
                        maxLines: 1,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.thirdElement,
                          fontSize: 16.sp,
                          fontFamily: "Avenir",
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                      height: 12, child: Image.asset('assets/icons/ang.png')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
