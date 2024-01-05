import 'package:chatty/common/services/services.dart';
import 'package:chatty/common/store/store.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Global {
  static Future init() async {
    WidgetsFlutterBinding.ensureInitialized();

    await Firebase.initializeApp();
    await Get.putAsync<StorageService>(() => StorageService().init());
    Get.put<ConfigStore>(ConfigStore());
    Get.put<UserStore>(UserStore());
  }
}
