import "dart:async";

import 'package:get/get.dart';
import 'package:remaze/TestData/test_map.dart';

import '../TestData/editor_page.dart';
import '../models/maze_map.dart';

class GameActController extends GetxController {
  var _timer;
  Rx<String> _yourRole = 'A'.obs;
  String get yourRole => _yourRole.value;

  Rx<bool> showSkills = false.obs;
  Rx<bool> _frozenActivate = false.obs;
  Rx<bool> _teleportDoor = false.obs;
  Rx<bool> _teleportExit = false.obs;
  bool get frozenActivate => _frozenActivate.value;
  bool get teleportDoor => _teleportDoor.value;
  bool get teleportExit => _teleportExit.value;

  Rx<Direction> moveDirection = Direction.up.obs;
  late Rx<MazeMap> _mazeMap = EditorPageMap.createStruct(TestData.createTestMap()).obs;
  MazeMap get mazeMap => _mazeMap.value;
  @override
  void onInit() {
    runEngine();
    super.onInit();
  }

  @override
  void onClose() {
    _timer.cancel();
    _timer = null;
    super.onClose();
  }

  void runEngine() async {
    _timer = Timer.periodic(Duration(milliseconds: 1000), (timer) {
      print(moveDirection.value.toString());
      _mazeMap.value.MovePlayer_A(moveDirection.value);
      update();
    });
  }

  void useFrozen() {
    _frozenActivate.value = true;
    update();
  }

  void doorTeleport() {
    _teleportDoor.value = true;
    update();
  }

  void exitTeleport() {
    _teleportExit.value = true;
    update();
  }
}
