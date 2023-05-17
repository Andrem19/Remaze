import 'package:remaze/models/cube.dart';
import 'package:remaze/models/maze_map.dart';

class Compare {
  static bool compareCoord(Coordinates coord, Cube cube) {
    if (coord.row == cube.row && coord.col == cube.col) {
      return true;
    }
    return false;
  }
}
