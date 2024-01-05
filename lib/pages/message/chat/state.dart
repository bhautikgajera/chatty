import 'package:chatty/common/entities/entities.dart';
import 'package:get/get.dart';

class ChatState {
  RxList<Msgcontent> msgContentList = <Msgcontent>[].obs;

  var to_token = "".obs;

  var to_name = "".obs;

  var to_avatar = "".obs;

  var to_online = "".obs;

  RxBool moreState = false.obs;

  RxBool isLoading = false.obs;
}
