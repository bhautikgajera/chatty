import 'package:chatty/common/values/values.dart';
import 'package:chatty/pages/contact/controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'widgets/contact_list.dart';

class ContactPage extends GetView<ContactController> {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: SizedBox(
        height: 780.h,
        width: 360.w,
        child: const ContactList(),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text(
        controller.title,
        style: TextStyle(
          color: AppColors.primaryText,
          fontSize: 16.sp,
        ),
      ),
    );
  }
}
