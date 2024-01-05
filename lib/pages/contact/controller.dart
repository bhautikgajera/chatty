import 'package:chatty/common/entities/entities.dart';
import 'package:chatty/common/store/store.dart';
import 'package:chatty/pages/contact/state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:chatty/common/apis/apis.dart';

class ContactController extends GetxController {
  final title = "Contacts";

  final state = ContactState();

  final token = UserStore.to.profile.token;

  final db = FirebaseFirestore.instance;

  @override
  void onReady() {
    asyncLoadAllData();
    super.onReady();
  }

  void goChat(ContactItem contactItem) async {
    final from_Message = await db
        .collection('message')
        .withConverter(
          fromFirestore: Msg.fromFirestore,
          toFirestore: (value, options) => value.toFirestore(),
        )
        .where('from_token', isEqualTo: token)
        .where('to_token', isEqualTo: contactItem.token)
        .get();

    final to_Message = await db
        .collection('message')
        .withConverter(
          fromFirestore: Msg.fromFirestore,
          toFirestore: (value, options) => value.toFirestore(),
        )
        .where('from_token', isEqualTo: contactItem.token)
        .where('to_token', isEqualTo: token)
        .get();

    if (from_Message.docs.isEmpty && to_Message.docs.isEmpty) {
      var profile = UserStore.to.profile;
      var msgData = Msg(
        from_token: profile.token,
        to_token: contactItem.token,
        from_name: profile.name,
        to_name: contactItem.name,
        from_avatar: profile.avatar,
        to_avatar: contactItem.avatar,
        from_online: profile.online,
        to_online: contactItem.online,
        last_msg: "",
        last_time: Timestamp.now(),
        msg_num: 0,
      );

      final msg_doc = await db
          .collection('message')
          .withConverter(
            fromFirestore: Msg.fromFirestore,
            toFirestore: (value, options) => value.toFirestore(),
          )
          .add(msgData);
      print(".... Creating New Document And adding user info done ...");

      var args = <String, String>{
        "doc_id": msg_doc.id,
        "to_token": contactItem.token ?? "",
        "to_name": contactItem.name ?? "",
        "to_avatar": contactItem.avatar ?? "",
        "to_online": contactItem.online?.toString() ?? "",
      };
      Get.toNamed(
        '/chat',
        parameters: args,
      );
    } else {
      if (from_Message.docs.isNotEmpty) {
        var args = <String, String>{
          "doc_id": from_Message.docs.first.id,
          "to_token": contactItem.token ?? "",
          "to_name": contactItem.name ?? "",
          "to_avatar": contactItem.avatar ?? "",
          "to_online": contactItem.online?.toString() ?? "",
        };
        Get.toNamed(
          '/chat',
          parameters: args,
        );
      }

      if (to_Message.docs.isNotEmpty) {
        var args = <String, String>{
          "doc_id": to_Message.docs.first.id,
          "to_token": contactItem.token ?? "",
          "to_name": contactItem.name ?? "",
          "to_avatar": contactItem.avatar ?? "",
          "to_online": contactItem.online?.toString() ?? "",
        };
        Get.toNamed(
          '/chat',
          parameters: args,
        );
      }
    }
  }

  void asyncLoadAllData() {
    EasyLoading.show(
        indicator: const CircularProgressIndicator(),
        maskType: EasyLoadingMaskType.clear,
        dismissOnTap: true);

    state.contactList.clear();
    final result = ContactAPI.post_contact();
    result.then((value) {
      if (value.code == 0) {
        print("<<<<<<<<<<<<<${value.data}>>>>>>>>>>>>>");
        state.contactList.addAll(value.data!);
      }
      EasyLoading.dismiss();
    });
  }
}
