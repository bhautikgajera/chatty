import 'package:get/get.dart';

class VoiceCallState {
  RxBool isJoin = false.obs;

  RxBool openMicrophone = true.obs;

  RxBool enableSpeaker = true.obs;

  RxString callTime = "00.00".obs;

  RxString callTimeStatus = "not connected".obs;

  var toToken = "".obs;

  var toAvatar = "".obs;

  var toName = "".obs;

  var docId = "".obs;

  // reciver is a audience

  // caller is anchor

  var callRole = "audience".obs;

  var channelId = "".obs;
}
