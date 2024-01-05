import 'package:chatty/pages/profile/index.dart';
import 'package:flutter/material.dart';
import 'index.dart';
import 'package:get/get.dart';

class ProfilePage extends GetView<ProfileController> {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                children: [
                  buildProfilePhoto(controller),
                  buildCompleteBtn(),
                  buildLogOutBtn(controller),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
