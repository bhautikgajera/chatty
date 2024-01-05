import 'dart:convert';

import 'package:chatty/common/apis/apis.dart';
import 'package:chatty/common/entities/user.dart';
import 'package:chatty/common/routes/routes.dart';
import 'package:chatty/common/store/store.dart';
import 'package:chatty/common/utils/utils.dart';
import 'package:chatty/pages/frame/sign_in/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SignInController extends GetxController {
  final String title = "SignIn Title";

  final state = SignInState();

  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: [
    'openid',
  ]);

  Future<void> handleSignIn(String type) async {
    // 1:Email,  2: google, 3: facebook, 4:apple, 5, phone
    try {
      if (type == "phone number") {
        print("... you are loggin with phone number ...");
      } else if (type == "Google") {
        final user = await _googleSignIn.signIn();
        if (user != null) {
          String? name = user.displayName;
          String email = user.email;
          String id = user.id;
          String? photoUrl = user.photoUrl;
          LoginRequestEntity loginPanelListRequestEntity = LoginRequestEntity(
              name: name, email: email, avatar: photoUrl, open_id: id, type: 2);

          print(jsonEncode(loginPanelListRequestEntity));
          asyncPostAllData(loginPanelListRequestEntity);
        }
      } else {
        print("...login type not sure...");
      }
    } catch (e) {
      print("...Error With Logon... $e");
    }
  }

  asyncPostAllData(LoginRequestEntity loginRequestEntity) async {
    // print("...Going To Message Page...");
    // var response = await HttpUtil().get("/api/index");
    //
    // print("Response =>>>>>>> $response");
    EasyLoading.show(
      indicator: CircularProgressIndicator(),
      maskType: EasyLoadingMaskType.clear,
      dismissOnTap: true,
    );
    final resut = await UserAPI.Login(params: loginRequestEntity);
    if (resut.code == 0) {
      await UserStore.to.saveProfile(resut.data!);
      EasyLoading.dismiss();
    } else {
      EasyLoading.dismiss();
      Fluttertoast.showToast(msg: "Internet Error");
    }

    Get.offAllNamed(AppRoutes.Message);
  }
}
