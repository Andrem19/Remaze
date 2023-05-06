import "dart:async";
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../models/maze_map.dart';

class GameActController extends GetxController {
  GameActController({required this.mazeMap});

  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  int time = 600;
  Duration clockTimer = Duration(seconds: 600);
  Rx<String> timerText = ''.obs;
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
  Rx<MazeMap> mazeMap;
  // late Rx<MazeMap> _mazeMap =
  //     EditorPageMap.createStruct(TestData.createTestMap()).obs;
  // MazeMap get mazeMap => _mazeMap.value;
  @override
  void onInit() {
    runEngine();
    super.onInit();
  }

  @override
  void onClose() {
    stopEngine();
    super.onClose();
  }

  void stopEngine() {
    _timer.cancel();
    _timer = null;
  }

  void runEngine() async {
    _timer = Timer.periodic(Duration(milliseconds: 1000), (timer) {
      print(moveDirection.value.toString());
      mazeMap.value.MovePlayer_A(moveDirection.value);
      time--;
      clockTimer = Duration(seconds: time);
      timerText.value =
          '${clockTimer.inMinutes.remainder(60).toString()}:${clockTimer.inSeconds.remainder(60).toString().padLeft(2, '0')}';
      update();
      if (time < 1) {
        gameEnd();
      }
    });
  }

  void gameEnd() {}

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
