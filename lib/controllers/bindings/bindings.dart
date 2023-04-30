import 'package:get/get.dart';

import '../game_act_controller.dart';

class MainScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(GameActController(), permanent: true);
  }
}