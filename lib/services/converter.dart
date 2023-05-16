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
        return 'down';
        break;
      case Direction.down:
        return 'up';
        break;
      case Direction.left:
        return 'right';
        break;
      case Direction.right:
        return 'left';
        break;
      default:
      return 'up';
    }
  }
}
