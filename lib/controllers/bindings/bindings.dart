import 'package:get/get.dart';
import 'package:remaze/controllers/main_game_controller.dart';
import 'package:remaze/controllers/map_editor_controller.dart';

import '../game_act_controller.dart';

class MainScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(MainGameController(), permanent: true);
  }
}

class GameActBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(GameActController(), permanent: false);
  }
}

class MapEditorBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(MapEditorController(), permanent: false);
  }
}