import 'dart:math';

import 'package:remaze/models/maze_map.dart';

import '../models/cube.dart';

class TestData {
  MazeMap createTestMap() {
    List<List<Cube>> maze = List.generate(60, (row) {
      return List.generate(30, (col) {
        return Cube(
            row: row,
            col: col,
            wall: false,
            is_A_START: false,
            is_B_START: false,
            isCheeseHere: false,
            isPlayer_A_Here: false,
            isPlayer_B_Here: false,
            isFrozen_A_Here: false,
            isFrozen_B_Here: false,
            isTeleportDoor_A_Here: false,
            isTeleportExit_A_Here: false,
            isTeleportDoor_B_Here: false,
            isTeleportExit_B_Here: false,
            isBorder: false);
      });
    });
    maze[0][0].isPlayer_A_Here = true;
    maze[59][29].isPlayer_B_Here = true;
    return MazeMap(
        mazeMap: maze,
        Player_A_Coord: Coordinates(isInit: true, row: 0, col: 0),
        Player_B_Coord: Coordinates(isInit: true, row: 59, col: 29),
        A_FrozenInstalled: false,
        B_FrozenInstalled: false,
        A_DoorInstalled: false,
        B_DoorInstalled: false,
        A_ExitInstalled: false,
        B_ExitInstalled: false,
        Player_A_Frozen: 0,
        Player_B_Frozen: 0,
        ExitTeleport_A: Coordinates(isInit: false, row: 0, col: 0),
        ExitTeleport_B: Coordinates(isInit: false, row: 0, col: 0));
  }
}
