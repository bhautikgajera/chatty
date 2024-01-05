import 'dart:io';

import 'package:chatty/common/apis/apis.dart';
import 'package:chatty/common/entities/entities.dart';
import 'package:chatty/common/routes/routes.dart';
import 'package:chatty/common/store/store.dart';
import 'package:chatty/common/widgets/widgets.dart';
import 'package:chatty/pages/message/chat/state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ChatController extends GetxController {
  final title = "Chat";

  final state = ChatState();

  late final String docId;

  final TextEditingController myInputController = TextEditingController();

  // get the user or senders token
  final token = UserStore.to.profile.token;

  // firebase data instance

  final db = FirebaseFirestore.instance;

  var listener;
  bool isLoadMore = true;

  final ScrollController myScrollController = ScrollController();

  void goMore() {
    state.moreState.value = !state.moreState.value;
  }

  void voiceCall() {
    state.moreState.value = false;
    Get.toNamed(AppRoutes.VoiceCall, parameters: {
      'to_token': state.to_token.value,
      'to_name': state.to_name.value,
      'to_avatar': state.to_avatar.value,
      "call_role": "anchor",
      'doc_id': docId
    });
  }

  Future<bool> requestPermission(Permission permission) async {
    var permissionStatus = await permission.status;
    if (permissionStatus != PermissionStatus.granted) {
      var ststus = await permission.request();
      if (ststus != PermissionStatus.granted) {
        toastInfo(msg: "Please enable permission have video call");
        if (GetPlatform.isAndroid) {
          await openAppSettings();
        }
        return false;
      }
    }
    return true;
  }

  void videoCall() async {
    state.moreState.value = false;

    bool micStatus = await requestPermission(Permission.microphone);

    bool camStatus = await requestPermission(Permission.camera);

    if (GetPlatform.isAndroid && micStatus && camStatus) {
      Get.toNamed(AppRoutes.VideoCall, parameters: {
        'to_token': state.to_token.value,
        'to_name': state.to_name.value,
        'to_avatar': state.to_avatar.value,
        "call_role": "anchor",
        'doc_id': docId
      });
    } else {
      Get.toNamed(AppRoutes.VideoCall, parameters: {
        'to_token': state.to_token.value,
        'to_name': state.to_name.value,
        'to_avatar': state.to_avatar.value,
        "call_role": "anchor",
        'doc_id': docId
      });
    }
  }

  @override
  void onInit() {
    final data = Get.parameters;

    print(data);

    docId = data['doc_id']!;

    state.to_token.value = data['to_token'] ?? "";

    state.to_name.value = data['to_name'] ?? "";

    state.to_avatar.value = data['to_avatar'] ?? "";

    state.to_online.value = data['to_online'] ?? "1";

    clearMsgNum();

    super.onInit();
  }

  // clearing Red dots

  void clearMsgNum() async {
    final messageResult = await db
        .collection('message')
        .withConverter(
          fromFirestore: Msg.fromFirestore,
          toFirestore: (value, options) => value.toFirestore(),
        )
        .doc(docId)
        .get();

    if (messageResult.data() != null) {
      final item = messageResult.data()!;
      int to_msg_num = item.to_msg_num ?? 0;
      int from_msg_num = item.from_msg_num ?? 0;

      if (item.from_token == token) {
        to_msg_num = 0;
      } else {
        from_msg_num = 0;
      }

      await db.collection('message').doc(docId).update(
        {
          'to_msg_num': to_msg_num,
          'from_msg_num': from_msg_num,
        },
      );
    }
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
    listenMessages();
    scrollerListener();
  }

  final ImagePicker _picker = ImagePicker();
  late File _photo;
  void imgFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _photo = File(pickedFile.path);
      uploadImage();
    }
  }

  void uploadImage() async {
    var result = await ChatAPI.upload_img(file: _photo);
    print(result.data);
    if (result.code == 0) {
      sendImageMessage(result.data!);
    } else {
      toastInfo(msg: "sending image error");
    }
  }

  void listenMessages() {
    state.msgContentList.clear();

    final messages = db
        .collection('message')
        .doc(docId)
        .collection('msglist')
        .withConverter(
          fromFirestore: Msgcontent.fromFirestore,
          toFirestore: (msgContent, options) => msgContent.toFirestore(),
        )
        .orderBy('addtime', descending: true)
        .limit(15);

    listener = messages.snapshots().listen(
      (event) {
        List<Msgcontent> tempMsgContentList = [];

        for (var change in event.docChanges) {
          switch (change.type) {
            case DocumentChangeType.added:
              if (change.doc.data() != null) {
                tempMsgContentList.add(change.doc.data()!);
              }
            case DocumentChangeType.modified:
            // TODO: Handle this case.
            case DocumentChangeType.removed:
            // TODO: Handle this case.
          }
        }

        tempMsgContentList.reversed.forEach((element) {
          state.msgContentList.value.insert(0, element);
        });

        state.msgContentList.refresh();
        if (myScrollController.hasClients) {
          myScrollController.animateTo(
              myScrollController.position.minScrollExtent,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut);
        }
      },
    );
  }

  void scrollerListener() {
    myScrollController.addListener(() {
      if ((myScrollController.offset + 20) >
          (myScrollController.position.maxScrollExtent)) {
        if (isLoadMore) {
          state.isLoading.value = true;
          isLoadMore = false;
          asyncLoadMoreData();
        }
      }
    });
  }

  void asyncLoadMoreData() async {
    final messages = await db
        .collection('message')
        .doc(docId)
        .collection('msglist')
        .withConverter(
            fromFirestore: Msgcontent.fromFirestore,
            toFirestore: (msg, options) => msg.toFirestore())
        .orderBy('addtime', descending: true)
        .where('addtime', isLessThan: state.msgContentList.last.addtime)
        .limit(10)
        .get();

    if (messages.docs.isNotEmpty) {
      messages.docs.forEach((element) {
        var data = element.data();
        state.msgContentList.value.add(data);
      });
    }
    state.msgContentList.refresh();

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      isLoadMore = true;
    });

    state.isLoading.value = false;
  }

  void sendImageMessage(String url) async {
    //created and object to send to firebase
    final content = Msgcontent(
      token: token,
      content: url,
      type: "image",
      addtime: Timestamp.now(),
    );

    await db
        .collection('message')
        .doc(docId)
        .collection('msglist')
        .withConverter(
          fromFirestore: Msgcontent.fromFirestore,
          toFirestore: (msg, options) => msg.toFirestore(),
        )
        .add(content)
        .then((doc) {});

    // collection().get().docs.data()
    var messageResult = await db
        .collection('message')
        .doc(docId)
        .withConverter(
          fromFirestore: Msg.fromFirestore,
          toFirestore: (msg, options) {
            return msg.toFirestore();
          },
        )
        .get();

    if (messageResult.data() != null) {
      var item = messageResult.data()!;

      int to_msg_num = item.to_msg_num == null ? 0 : item.to_msg_num!;
      int from_msg_num = item.from_msg_num == null ? 0 : item.from_msg_num!;

      if (item.from_token == token) {
        from_msg_num = from_msg_num + 1;
      } else {
        to_msg_num = to_msg_num + 1;
      }

      await db.collection('message').doc(docId).update(
        {
          'to_msg_num': to_msg_num,
          'from_msg_num': from_msg_num,
          'last_msg': "<img>",
          'last_time': Timestamp.now(),
        },
      );
    }
  }

  void sendMessage() async {
    String sendContent = myInputController.text;
    if (sendContent.isEmpty) {
      toastInfo(msg: "content is empty");
      return;
    }
    //created and object to send to firebase
    final content = Msgcontent(
      token: token,
      content: sendContent,
      type: "text",
      addtime: Timestamp.now(),
    );

    await db
        .collection('message')
        .doc(docId)
        .collection('msglist')
        .withConverter(
          fromFirestore: Msgcontent.fromFirestore,
          toFirestore: (msg, options) => msg.toFirestore(),
        )
        .add(content)
        .then((doc) {
      myInputController.clear();
    });

    // collection().get().docs.data()
    var messageResult = await db
        .collection('message')
        .doc(docId)
        .withConverter(
          fromFirestore: Msg.fromFirestore,
          toFirestore: (msg, options) {
            return msg.toFirestore();
          },
        )
        .get();

    if (messageResult.data() != null) {
      var item = messageResult.data()!;

      int to_msg_num = item.to_msg_num == null ? 0 : item.to_msg_num!;
      int from_msg_num = item.from_msg_num == null ? 0 : item.from_msg_num!;

      if (item.from_token == token) {
        from_msg_num = from_msg_num + 1;
      } else {
        to_msg_num = to_msg_num + 1;
      }

      await db.collection('message').doc(docId).update(
        {
          'to_msg_num': to_msg_num,
          'from_msg_num': from_msg_num,
          'last_msg': sendContent,
          'last_time': Timestamp.now(),
        },
      );
    }
  }

  void closeAllPops() {
    Get.focusScope?.unfocus();

    state.moreState.value = false;
  }

  @override
  void onClose() {
    super.onClose();
    listener.cancel();
    myInputController.dispose();
    myScrollController.dispose();
    clearMsgNum();
  }
}
