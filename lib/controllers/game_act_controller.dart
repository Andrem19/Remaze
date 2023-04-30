import "dart:async";

import 'package:get/get.dart';
import 'package:remaze/TestData/test_map.dart';

import '../models/maze_map.dart';

class GameActController extends GetxController {
  var _timer;
  Rx<bool> showSkills = false.obs;
  Rx<Direction> moveDirection = Direction.up.obs;
  late Rx<MazeMap> mazeMap = TestData.createTestMap().obs;
  @override
  void onInit() {
    runEngine();
    super.onInit();
  }

  @override
  void dispose() {
    _timer.cancel();
    _timer = null;
    super.dispose();
  }

  void runEngine() async {
    _timer = Timer.periodic(Duration(milliseconds: 1000), (timer) {
      print(moveDirection.value.toString());
      mazeMap.value.MovePlayer_A(moveDirection.value);
      update();
    });
  }
}
