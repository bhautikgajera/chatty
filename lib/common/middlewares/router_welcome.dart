import 'package:flutter/material.dart';
import 'package:chatty/common/routes/routes.dart';
import 'package:chatty/common/store/store.dart';

import 'package:get/get.dart';

/// Check if User has logged in
class RouteWelcomeMiddleware extends GetMiddleware {
  // priority Smaller the better
  @override
  int? priority = 0;

  RouteWelcomeMiddleware({required this.priority});

  @override
  RouteSettings? redirect(String? route) {
    print(ConfigStore.to.isFirstOpen);

    if(UserStore.to.isLogin || route == AppRoutes.SIGN_IN || route == AppRoutes.INITIAL){
      return null;
    }else{
      Future.delayed(const Duration(seconds: 2),()=> Get.snackbar("Tips", "Login Expired Please Login Again"),);

      return const RouteSettings(name: AppRoutes.SIGN_IN);
    }

    if (ConfigStore.to.isFirstOpen == false) {
      return null;
    } else if (UserStore.to.isLogin == true) {
      return RouteSettings(name: AppRoutes.Message);
    } else {
      return RouteSettings(name: AppRoutes.SIGN_IN);
    }
  }
}
