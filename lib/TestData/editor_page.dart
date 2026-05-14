import 'package:remaze/models/maze_map.dart';

import '../models/cube.dart';

class EditorPageMap {
  static MazeMap createStruct(MazeMap mazeMap) {
    double middleHigh = mazeMap.mazeMap.length / 2;
    double middleWidth = mazeMap.mazeMap[0].length / 2;

    mazeMap.mazeMap[middleHigh.toInt()][middleWidth.toInt()].isCheeseHere = true;

    mazeMap.mazeMap[middleHigh.toInt() - 2][middleWidth.toInt() + 2].wall = true;
    mazeMap.mazeMap[middleHigh.toInt() - 1][middleWidth.toInt() + 2].wall = true;
    mazeMap.mazeMap[middleHigh.toInt()][middleWidth.toInt() + 2].wall = true;
    mazeMap.mazeMap[middleHigh.toInt() + 1][middleWidth.toInt() + 2].wall = true;
    mazeMap.mazeMap[middleHigh.toInt() + 2][middleWidth.toInt() + 2].wall = true;

    mazeMap.mazeMap[middleHigh.toInt() + 2][middleWidth.toInt() + 1].wall = true;
    // maze[middleHigh.toInt()+2][middleWidth.toInt()].wall = false;
    mazeMap.mazeMap[middleHigh.toInt() + 2][middleWidth.toInt() - 1].wall = true;
    mazeMap.mazeMap[middleHigh.toInt() + 2][middleWidth.toInt() - 2].wall = true;

    mazeMap.mazeMap[middleHigh.toInt() + 1][middleWidth.toInt() - 2].wall = true;
    mazeMap.mazeMap[middleHigh.toInt()][middleWidth.toInt() - 2].wall = true;
    mazeMap.mazeMap[middleHigh.toInt() - 1][middleWidth.toInt() - 2].wall = true;
    mazeMap.mazeMap[middleHigh.toInt() - 2][middleWidth.toInt() - 2].wall = true;

    mazeMap.mazeMap[middleHigh.toInt() - 2][middleWidth.toInt() - 1].wall = true;
    // maze[middleHigh.toInt()-2][middleWidth.toInt()].wall = false;
    mazeMap.mazeMap[middleHigh.toInt() - 2][middleWidth.toInt() + 1].wall = true;
    for (var i = 0; i < mazeMap.mazeMap[0].length; i++) {
      mazeMap.mazeMap[middleHigh.toInt()][i].wall = true;
    }
    mazeMap.mazeMap[middleHigh.toInt()][middleWidth.toInt()].wall = false;
    mazeMap.mazeMap[middleHigh.toInt()][middleWidth.toInt() + 1].wall = false;
    mazeMap.mazeMap[middleHigh.toInt()][middleWidth.toInt() - 1].wall = false;

    return mazeMap;
  }
}
