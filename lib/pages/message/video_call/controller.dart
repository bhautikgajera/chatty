import 'dart:async';
import 'dart:convert';

import 'package:chatty/common/apis/apis.dart';
import 'package:chatty/common/entities/chat.dart';
import 'package:chatty/common/entities/entities.dart';
import 'package:chatty/common/store/store.dart';
import 'package:chatty/common/values/server.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:permission_handler/permission_handler.dart';

import 'state.dart';

class VideoCallController extends GetxController {
  final title = "Voice Call";

  final state = VideoCallState();

  final player = AudioPlayer();

  String appId = "a9728b4c06a940fa815cddbffd2d84b0";

  final db = FirebaseFirestore.instance;

  final profileToken = UserStore.to.profile.token;

  late final RtcEngine engine;

  int call_s = 0;
  int call_m = 0;
  int call_h = 0;

  late final Timer callTimer;

  ChannelProfileType channelProfileType =
      ChannelProfileType.channelProfileCommunication;

  @override
  void onInit() {
    print("OnInIt Called");
    final data = Get.parameters;
    state.toName.value = data['to_name'] ?? "-";
    state.toAvatar.value = data['to_avatar'] ?? "";
    state.callRole.value = data['call_role'] ?? "";
    state.docId.value = data['doc_id'] ?? "";
    state.toToken.value = data['to_token'] ?? "";

    initEngine();
    super.onInit();
  }

  /// [initEngine] this method call to initialize agora SDk
  Future<void> initEngine() async {
    print("Init Called");
    await [Permission.microphone, Permission.camera].request();
    // play sound when this method call
    await player.setAsset('assets/Sound_Horizon.mp3');
    // create new RtcEngine Instance and assigned it to engine variable
    engine = createAgoraRtcEngine();

    // initialize
    await engine.initialize(RtcEngineContext(appId: appId));

    engine.registerEventHandler(
      RtcEngineEventHandler(
        onError: (err, msg) {
          print("[$err] => $msg");
        },
        onJoinChannelSuccess: (connection, elapsed) {
          print("onConnection Success =>>>>  ${connection.toJson()}");
          state.isJoin.value = true;
        },
        onUserJoined: (connection, remoteUid, elapsed) async {
          state.onRemoteUID.value = remoteUid;
          state.isShowAvatar.value = false;

          await player.pause();

          callTime();
        },
        onLeaveChannel: (connection, stats) {
          print("my Stats User Left the Room => ${stats.toJson()}");
          state.isJoin.value = false;
          state.onRemoteUID.value = 0;
          state.isShowAvatar.value = true;
        },
        onRtcStats: (connection, stats) {
          print("Time....");
          print(stats.duration);
          print("Status >>>");
          print(stats);
        },
      ),
    );

    await engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);

    await engine.enableVideo();

    await engine.setVideoEncoderConfiguration(const VideoEncoderConfiguration(
      dimensions: VideoDimensions(
        height: 360,
        width: 640,
      ),
      frameRate: 15,
      bitrate: 0,
    ));

    await engine.startPreview();

    state.isReadyPreview.value = true;

    await joinChannel();

    if (state.callRole.value == "anchor") {
      await player.play();
    }
  }

  void callTime() {
    callTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      call_s = call_s + 1;
      if (call_s >= 60) {
        call_s = 0;
        call_m = call_m + 1;
      }
      if (call_m >= 60) {
        call_m = 0;
        call_h = call_h + 1;
      }
      state.callTime.value = "$call_h:$call_m:$call_s}";
    });
  }

  Future<void> sendNotification(String callType) async {
    CallRequestEntity callRequestEntity = CallRequestEntity();
    callRequestEntity.call_type = callType;

    callRequestEntity.to_token = state.toToken.value;
    callRequestEntity.to_avatar = state.toAvatar.value;
    callRequestEntity.doc_id = state.docId.value;

    var res = await ChatAPI.call_notifications(params: callRequestEntity);

    if (res.code == 0) {
      print("notification success");
      print(">>>>>>>  ${res.data}  ");
    } else {
      print(res.msg);
      print("could not send notification");
    }
  }

  Future<String> getToken() async {
    state.channelId.value =
        md5.convert(utf8.encode("${profileToken}_${state.toToken}")).toString();

    print(".... channel id is ${state.channelId.value}");

    CallTokenRequestEntity callTokenRequestEntity = CallTokenRequestEntity();

    callTokenRequestEntity.channel_name = state.channelId.value;

    var res = await ChatAPI.call_token(params: callTokenRequestEntity);
    if (res.code == 0) {
      return res.data ?? "";
    } else {
      return "";
    }
  }

  Future<void> joinChannel() async {
    // final status = await Permission.microphone.request();

    await [Permission.microphone, Permission.camera].request();

    await sendNotification("video");

    EasyLoading.show(
      indicator: const CircularProgressIndicator(),
      maskType: EasyLoadingMaskType.clear,
      dismissOnTap: true,
    );

    final token = await getToken();

    if (token.isEmpty) {
      EasyLoading.dismiss();
      Get.back();
    }

    print(".........  token => $token");

    print("..........  to_token => ${state.toToken.value}");

    print("Channel ID ->>>>> ${state.channelId.value}");

    await engine.joinChannel(
      token:
          "007eJxTYFAsDWIM57WaI6q8VOzeam++JzOSGy6+PM+flbj/ZzoTf48CQ6KluZFFkkmygVmipYlBWqKFoWlySkpSWlqKUYqFSZKBzbxpqQ2BjAxfig4xMTJAIIjPyVCSWlyia2hkbMLAAABBuB9s",
      channelId: "test-1234",
      uid: 0,
      options: ChannelMediaOptions(
        channelProfile: channelProfileType,
        clientRoleType: ClientRoleType.clientRoleBroadcaster,
      ),
    );

    EasyLoading.dismiss();
  }

  void leaveChannel() {
    EasyLoading.show(
      indicator: const CircularProgressIndicator(),
      maskType: EasyLoadingMaskType.clear,
      dismissOnTap: true,
    );

    sendNotification("cancle");

    player.pause();

    state.isJoin.value = false;

    state.switchCamera.value = true;

    EasyLoading.dismiss();

    Get.back();
  }

  Future<void> switchCamera() async {
    await engine.switchCamera();
    state.switchCamera.toggle();
  }

  void addCallTime() async {
    var profile = UserStore.to.profile;
    var msgData = ChatCall(
      from_token: profile.token,
      to_token: state.toToken.value,
      from_name: profile.name,
      to_name: state.toName.value,
      from_avatar: profile.avatar,
      to_avatar: state.toAvatar.value,
      call_time: state.callTime.value,
      type: 'video',
      last_time: Timestamp.now(),
    );

    await db
        .collection('chatcall')
        .withConverter(
          fromFirestore: ChatCall.fromFirestore,
          toFirestore: (value, options) {
            return value.toFirestore();
          },
        )
        .add(msgData);

    String sendContent = "Call time ${state.callTime.value} [Video]";
    saveMessage(sendContent);
  }

  saveMessage(String sendContent) async {
    if (state.docId.value.isEmpty) {
      return;
    }
    final content = Msgcontent(
      token: profileToken,
      content: sendContent,
      type: 'text',
      addtime: Timestamp.now(),
    );

    await db
        .collection('message')
        .doc(state.docId.value)
        .collection('msglist')
        .withConverter(
          fromFirestore: Msgcontent.fromFirestore,
          toFirestore: (value, options) {
            return value.toFirestore();
          },
        )
        .add(content);

    var messageRes = await db
        .collection('message')
        .doc(state.docId.value)
        .withConverter(
          fromFirestore: Msg.fromFirestore,
          toFirestore: (value, options) {
            return value.toFirestore();
          },
        )
        .get();

    // todo Update message collection document and add update last message and time stamp
    // if (messageRes.data() != null) {
    //   var item = messageRes.data()!;
    //   final updateItem = Msg(
    //     last_time: Timestamp.now(),
    //     to_avatar: item.to_avatar,
    //     from_avatar: item.from_avatar,
    //     to_name: item.to_name,
    //     from_name: item.from_name,
    //     to_token: item.to_token,
    //     from_token: item.from_token,
    //     last_msg: sendContent,
    //     msg_num: (item.msg_num??0)+1,
    //     to_online: item.to_online,
    //     from_online: item.from_online,
    //     from_msg_num: item.from_msg_num,
    //     to_msg_num:
    //   );
    // }
  }

  Future<void> _dispose() async {
    if (state.callRole.value == 'anchor') {
      addCallTime();
    }
    callTimer.cancel();
    await player.pause();
    await engine.leaveChannel();
    await engine.release();
    await player.stop();
  }

  @override
  void onClose() {
    _dispose();
    super.onClose();
  }
}
