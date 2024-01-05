import 'dart:convert';

import 'package:chatty/common/apis/apis.dart';
import 'package:chatty/common/entities/chat.dart';
import 'package:chatty/common/store/store.dart';
import 'package:chatty/common/values/server.dart';
import 'package:chatty/pages/message/voice_call/state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:permission_handler/permission_handler.dart';

class VoiceCallController extends GetxController {
  final title = "Voice Call";

  final state = VoiceCallState();

  final player = AudioPlayer();

  String appId = "a9728b4c06a940fa815cddbffd2d84b0";

  final db = FirebaseFirestore.instance;

  final profileToken = UserStore.to.profile.token;

  late final RtcEngine engine;

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
          await player.pause();
        },
        onLeaveChannel: (connection, stats) {
          print("my Stats User Left the Room => ${stats.toJson()}");
          state.isJoin.value = false;
        },
        onRtcStats: (connection, stats) {
          print("Time....");
          print(stats.duration);
          print("Status >>>");
          print(stats);
        },
      ),
    );

    await engine.enableAudio();

    await engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);

    await engine.setAudioProfile(
      profile: AudioProfileType.audioProfileDefault,
      scenario: AudioScenarioType.audioScenarioGameStreaming,
    );
    await joinChannel();

    if (state.callRole.value == "anchor") {
      await player.play();
    }
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
    final status = await Permission.microphone.request();

    await sendNotification("voice");

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
          "007eJxTYGib1ZO75cjyVsk77j8O5DVIKj+4MU921sWGq5Lbile6TzyswJBoaW5kkWSSbGCWaGlikJZoYWianJKSlJaWYpRiYZJkMPvI5NSGQEaG5TF7mRkZIBDEZ2EoSS0uYWAAABhIIqk=",
      channelId: "test",
      uid: 0,
      options: const ChannelMediaOptions(
        channelProfile: ChannelProfileType.channelProfileGame,
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

    EasyLoading.dismiss();

    Get.back();
  }

  Future<void> _dispose() async {
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

  @override
  void dispose() async {
    super.dispose();
    print("Dispose Called");
    _dispose();
  }
}
