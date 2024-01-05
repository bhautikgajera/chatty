import 'package:chatty/common/apis/chat.dart';
import 'package:chatty/common/entities/base.dart';
import 'package:chatty/common/entities/entities.dart';
import 'package:chatty/common/routes/routes.dart';
import 'package:chatty/common/store/store.dart';
import 'package:chatty/pages/message/index.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class MessageController extends GetxController {
  MessageController();

  final state = MessageState();

  final db = FirebaseFirestore.instance;

  final token = UserStore.to.profile.token;

  void goProfile() async {
    await Get.toNamed(AppRoutes.Profile, arguments: state.headDetail.value);
  }

  void goTabStatus() {
    EasyLoading.show(
      indicator: const CircularProgressIndicator(),
      maskType: EasyLoadingMaskType.clear,
      dismissOnTap: true,
    );
    state.tabStatus.toggle();

    if (state.tabStatus.value) {
      asyncLoadMsgData();
    } else {}
    EasyLoading.dismiss();
  }

  void asyncLoadMsgData() async {
    var from_messages = await db
        .collection('message')
        .withConverter(
          fromFirestore: Msg.fromFirestore,
          toFirestore: (value, options) => value.toFirestore(),
        )
        .where('from_token', isEqualTo: token)
        .get();

    print(from_messages.docs.length);

    var to_messages = await db
        .collection('message')
        .withConverter(
          fromFirestore: Msg.fromFirestore,
          toFirestore: (value, options) => value.toFirestore(),
        )
        .where('to_token', isEqualTo: token)
        .get();

    print(to_messages.docs.length);

    if (from_messages.docs.isNotEmpty) {
      addMessage(from_messages.docs);
    }

    if (to_messages.docs.isNotEmpty) {
      addMessage(to_messages.docs);
    }
  }

  void addMessage(List<QueryDocumentSnapshot<Msg>> data) {
    state.msgList.clear();
    data.forEach((element) {
      var item = element.data();
      Message message = Message(
        doc_id: element.id,
        last_time: item.last_time,
        msg_num: item.msg_num,
        last_msg: item.last_msg,
      );

      if (item.from_token == token) {
        message.name = item.to_name;
        message.avatar = item.to_avatar;
        message.token = item.to_token;
        message.online = item.to_online;
        message.msg_num = item.to_msg_num ?? 0;
      } else {
        message.name = item.from_name;
        message.avatar = item.from_avatar;
        message.token = item.from_token;
        message.online = item.from_online;
        message.msg_num = item.from_msg_num ?? 0;
      }
      state.msgList.add(message);
    });
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
    firebaseMessageSetup();
  }

  @override
  void onInit() {
    getProfile();
    _snapShots();
    super.onInit();
  }

  void _snapShots() {
    final toMessageRef = db
        .collection('message')
        .withConverter(
          fromFirestore: Msg.fromFirestore,
          toFirestore: (value, options) {
            return value.toFirestore();
          },
        )
        .where('to_token', isEqualTo: token);

    final fromMessageRef = db
        .collection('message')
        .withConverter(
          fromFirestore: Msg.fromFirestore,
          toFirestore: (value, options) {
            return value.toFirestore();
          },
        )
        .where('from_token', isEqualTo: token);

    toMessageRef.snapshots().listen((event) {
      asyncLoadMsgData();
    });

    fromMessageRef.snapshots().listen((event) {
      asyncLoadMsgData();
    });
  }

  void getProfile() async {
    var profile = UserStore.to.profile;
    state.headDetail.value = profile;
    state.headDetail.refresh();
  }

  firebaseMessageSetup() async {
    String? fcmToken = await FirebaseMessaging.instance.getToken();
    print("My Device Token Is =>>>> $fcmToken");
    if (fcmToken != null) {
      BindFcmTokenRequestEntity bindFcmTokenRequestEntity =
          BindFcmTokenRequestEntity(fcmtoken: fcmToken);

      final res =
          await ChatAPI.bind_fcmtoken(params: bindFcmTokenRequestEntity);
      print(res.msg);
    }
  }
}
