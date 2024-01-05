import 'package:get/get.dart';

class VideoCallState {
  RxBool isJoin = false.obs;

  RxBool openMicrophone = true.obs;

  RxBool enableSpeaker = true.obs;

  RxString callTime = "00.00".obs;

  RxString callTimeStatus = "not connected".obs;

  RxString callTimeNum = "not connected".obs;

  var toToken = "".obs;

  var toAvatar = "".obs;

  var toName = "".obs;

  var docId = "".obs;

  // reciver is a audience

  // caller is anchor

  var callRole = "audience".obs;

  var channelId = "test-1234".obs;

  RxBool isReadyPreview = false.obs;

  // if user did not join show avatar
  RxBool isShowAvatar = true.obs;

  // change camera front and back
  RxBool switchCamera = true.obs;

  // remember remote id of the user from agora
  RxInt onRemoteUID = 0.obs;

  // default Time value
}
