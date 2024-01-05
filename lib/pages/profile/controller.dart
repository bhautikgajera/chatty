import 'package:chatty/common/store/store.dart';
import 'package:chatty/pages/profile/state.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ProfileController extends GetxController {
  final state = ProfileState();

  @override
  void onInit() {
    var userItem = Get.arguments;
    if (userItem != null) {
      state.profileDetail.value = userItem;
    }
    super.onInit();
  }

  void goLogout() async {
    await GoogleSignIn().signOut();
    await UserStore.to.onLogout();
  }
}
