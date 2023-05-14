import '../models/maze_map.dart';

class Conv {
  static Direction strToDir(String dirStr) {
    switch (dirStr) {
      case 'up':
        return Direction.up;
        break;
      case 'down':
        return Direction.down;
        break;
      case 'left':
        return Direction.left;
        break;
      case 'right':
        return Direction.right;
        break;
      default:
      return Direction.up;
    }
  }

  static String dirToStr(Direction direction) {
    switch (direction) {
      case Direction.up:
        return 'up';
        break;
      case Direction.down:
        return 'down';
        break;
      case Direction.left:
        return 'left';
        break;
      case Direction.right:
        return 'right';
        break;
      default:
      return 'up';
    }
  }
}
