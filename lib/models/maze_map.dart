// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:remaze/models/palyer.dart';

import 'cube.dart';

enum Direction { top, bottom, left, right }

class MazeMap {
  //Should be 60x30 cube
  List<List<Cube>> mazeMap;
  Player? player_A;
  Player? player_B;
  Coordinates Player_A_Coord;
  Coordinates Player_B_Coord;
  bool A_FrozenInstalled;
  bool B_FrozenInstalled;
  bool A_DoorInstalled;
  bool B_DoorInstalled;
  bool A_ExitInstalled;
  bool B_ExitInstalled;
  int Player_A_Frozen;
  int Player_B_Frozen;
  Coordinates ExitTeleport_A;
  Coordinates ExitTeleport_B;
  MazeMap({
    required this.mazeMap,
    required this.Player_A_Coord,
    required this.Player_B_Coord,
    required this.A_FrozenInstalled,
    required this.B_FrozenInstalled,
    required this.A_DoorInstalled,
    required this.B_DoorInstalled,
    required this.A_ExitInstalled,
    required this.B_ExitInstalled,
    required this.Player_A_Frozen,
    required this.Player_B_Frozen,
    required this.ExitTeleport_A,
    required this.ExitTeleport_B,
  });

  void movePlayer_A(Direction direction) {
    if (Player_A_Frozen != 0) {
      Player_A_Frozen -= 1;
      return;
    }
    switch (direction) {
      case Direction.top:
        if (Player_A_Coord.row != 0) {
          if (!mazeMap[Player_A_Coord.row - 1][Player_A_Coord.col].wall) {
            mazeMap[Player_A_Coord.row][Player_A_Coord.col].isPlayer_A_Here = false;
            mazeMap[Player_A_Coord.row - 1][Player_A_Coord.col].isPlayer_A_Here = true;
            Player_A_Coord.row -= 1;
          }
        }
        break;
      case Direction.bottom:
        if (Player_A_Coord.row != 59) {
          if (!mazeMap[Player_A_Coord.row + 1][Player_A_Coord.col].wall) {
            mazeMap[Player_A_Coord.row][Player_A_Coord.col].isPlayer_A_Here = false;
            mazeMap[Player_A_Coord.row + 1][Player_A_Coord.col].isPlayer_A_Here = true;
            Player_A_Coord.row += 1;
          }
        }
        break;
      case Direction.left:
        if (Player_A_Coord.col != 0) {
          if (!mazeMap[Player_A_Coord.row][Player_A_Coord.col - 1].wall) {
            mazeMap[Player_A_Coord.row][Player_A_Coord.col].isPlayer_A_Here = false;
            mazeMap[Player_A_Coord.row][Player_A_Coord.col - 1].isPlayer_A_Here = true;
            Player_A_Coord.col -= 1;
          }
        }
        break;
      case Direction.right:
        if (Player_A_Coord.row != 29) {
          if (!mazeMap[Player_A_Coord.row][Player_A_Coord.col + 1].wall) {
            mazeMap[Player_A_Coord.row][Player_A_Coord.col].isPlayer_A_Here = false;
            mazeMap[Player_A_Coord.row][Player_A_Coord.col + 1].isPlayer_A_Here = true;
            Player_A_Coord.col += 1;
          }
        }
        break;
      default:
    }
    if (mazeMap[Player_A_Coord.row][Player_A_Coord.col].isFrozen_B_Here) {
      Player_A_Frozen = 11;
    }

    if (mazeMap[Player_A_Coord.row][Player_A_Coord.col].isTeleportDoor_B_Here) {
      if (ExitTeleport_B.isInit) {
        mazeMap[Player_A_Coord.row][Player_A_Coord.col].isPlayer_A_Here = false;
        mazeMap[ExitTeleport_B.row][ExitTeleport_B.col].isPlayer_A_Here = true;
      }
    }
  }

  void instalFrozen_A() {
    if (!A_FrozenInstalled) {
      mazeMap[Player_A_Coord.row][Player_A_Coord.col].isFrozen_A_Here = true;
    }
  }

  void instalDoor_A() {
    if (!A_DoorInstalled) {
      mazeMap[Player_A_Coord.row][Player_A_Coord.col].isTeleportDoor_A_Here = true;
    }
  }

  void instalExit_A() {
    if (!A_ExitInstalled && A_DoorInstalled) {
      mazeMap[Player_A_Coord.row][Player_A_Coord.col].isTeleportExit_A_Here = true;
    }
  }
}

class Coordinates {
  bool isInit;
  int row;
  int col;
  Coordinates({
    required this.isInit,
    required this.row,
    required this.col,
  });
}
