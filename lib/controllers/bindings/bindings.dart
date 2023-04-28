import 'package:get/get.dart';

import '../main_game_controller.dart';

class MainScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(MainGameController(), permanent: true);
  }
}