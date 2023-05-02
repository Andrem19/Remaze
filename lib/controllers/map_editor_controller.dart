import 'package:get/get.dart';

import '../TestData/editor_page.dart';
import '../TestData/test_map.dart';
import '../models/maze_map.dart';

class MapEditorController extends GetxController {
  late Rx<MazeMap> _mazeMap =
      EditorPageMap.createStruct(TestData.createTestMap()).obs;
  MazeMap get mazeMap => _mazeMap.value;

  void changeWall(int row, int col) {
    if (_mazeMap.value.mazeMap[row][col].editAlowd) {
      _mazeMap.value.mazeMap[row][col].wall =
          !_mazeMap.value.mazeMap[row][col].wall;

      int mirrorRow = _mazeMap.value.mazeMap.length - row - 1;
      int mirrorCol = _mazeMap.value.mazeMap[0].length - col - 1;
      _mazeMap.value.mazeMap[mirrorRow][mirrorCol].wall =
          _mazeMap.value.mazeMap[row][col].wall;
    }
    update();
  }
}
