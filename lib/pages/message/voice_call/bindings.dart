import 'package:chatty/pages/message/voice_call/controller.dart';
import 'package:get/get.dart';

class VoiceCallBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VoiceCallController>(() => VoiceCallController());
  }
}
