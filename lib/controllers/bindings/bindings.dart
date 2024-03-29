import 'package:get/get.dart';
import 'package:remaze/controllers/ad_controller.dart';
import 'package:remaze/controllers/battle_controller.dart';
import 'package:remaze/controllers/fight_controller.dart';
import 'package:remaze/controllers/game_menu_controller.dart';
import 'package:remaze/controllers/invite_to_battle.dart';
import 'package:remaze/controllers/main_game_controller.dart';
import 'package:remaze/controllers/map_editor_controller.dart';
import 'package:remaze/controllers/qr_controller.dart';
import 'package:remaze/controllers/search_rival_controller.dart';

import '../../TestData/editor_page.dart';
import '../../TestData/test_map.dart';
import '../game_act_controller.dart';

class MainScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(MainGameController(), permanent: true);
    Get.put(AdController(), permanent: true);
  }
}

class GameActBinding extends Bindings {
  @override
  void dependencies() {
    var mainCtr = Get.find<MainGameController>();
    if (mainCtr.currentGameMap != null && mainCtr.currentMapId != null) {
      Get.put(GameActController(mazeMap: mainCtr.currentGameMap!.obs, mapId: mainCtr.currentMapId!), permanent: false);
    } else {
      Get.put(GameActController(mazeMap: EditorPageMap.createStruct(TestData.createTestMap()).obs, mapId: ''), permanent: false);
    }
    
  }
}

class GameMenuBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(GameMenuController(), permanent: false);
  }
}

class MapEditorBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(MapEditorController(), permanent: false);
  }
}

class QrControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(QrController(), permanent: false);
  }
}
class FightControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(FightController(), permanent: false);
  }
}
class SearchRivalBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SearchRivalController(), permanent: false);
  }
}
class InviteToBattleBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(InviteToBattle(), permanent: false);
  }
}
class BattleControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(BattleController(), permanent: false);
  }
}
