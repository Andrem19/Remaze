// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:remaze/models/palyer.dart';

import 'cube.dart';

enum Direction { up, down, left, right }

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
    this.player_A,
    this.player_B,
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

  void MovePlayer_A(Direction direction) {
    if (Player_A_Frozen != 0) {
      Player_A_Frozen -= 1;
      return;
    }
    switch (direction) {
      case Direction.up:
        if (Player_A_Coord.row != 0) {
          if (!mazeMap[Player_A_Coord.row - 1][Player_A_Coord.col].wall) {
            mazeMap[Player_A_Coord.row][Player_A_Coord.col].isPlayer_A_Here =
                false;
            mazeMap[Player_A_Coord.row - 1][Player_A_Coord.col]
                .isPlayer_A_Here = true;
            Player_A_Coord.row -= 1;
          }
        }
        break;
      case Direction.down:
        if (Player_A_Coord.row != mazeMap.length - 1) {
          if (!mazeMap[Player_A_Coord.row + 1][Player_A_Coord.col].wall) {
            mazeMap[Player_A_Coord.row][Player_A_Coord.col].isPlayer_A_Here =
                false;
            mazeMap[Player_A_Coord.row + 1][Player_A_Coord.col]
                .isPlayer_A_Here = true;
            Player_A_Coord.row += 1;
          }
        }
        break;
      case Direction.left:
        if (Player_A_Coord.col != 0) {
          if (!mazeMap[Player_A_Coord.row][Player_A_Coord.col - 1].wall) {
            mazeMap[Player_A_Coord.row][Player_A_Coord.col].isPlayer_A_Here =
                false;
            mazeMap[Player_A_Coord.row][Player_A_Coord.col - 1]
                .isPlayer_A_Here = true;
            Player_A_Coord.col -= 1;
          }
        }
        break;
      case Direction.right:
        if (Player_A_Coord.col != mazeMap[0].length - 1) {
          if (!mazeMap[Player_A_Coord.row][Player_A_Coord.col + 1].wall) {
            mazeMap[Player_A_Coord.row][Player_A_Coord.col].isPlayer_A_Here =
                false;
            mazeMap[Player_A_Coord.row][Player_A_Coord.col + 1]
                .isPlayer_A_Here = true;
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
      mazeMap[Player_A_Coord.row][Player_A_Coord.col].isTeleportDoor_A_Here =
          true;
    }
  }

  void instalExit_A() {
    if (!A_ExitInstalled && A_DoorInstalled) {
      mazeMap[Player_A_Coord.row][Player_A_Coord.col].isTeleportExit_A_Here =
          true;
    }
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'mazeMap': mazeMap.asMap().map((key, value) {
        return MapEntry(
            key.toString(),
            value.asMap().map((k, v) {
              return MapEntry(k.toString(), v.toMap());
            }));
      }),
      'player_A': player_A?.toMap(),
      'player_B': player_B?.toMap(),
      'Player_A_Coord': Player_A_Coord.toMap(),
      'Player_B_Coord': Player_B_Coord.toMap(),
      'A_FrozenInstalled': A_FrozenInstalled,
      'B_FrozenInstalled': B_FrozenInstalled,
      'A_DoorInstalled': A_DoorInstalled,
      'B_DoorInstalled': B_DoorInstalled,
      'A_ExitInstalled': A_ExitInstalled,
      'B_ExitInstalled': B_ExitInstalled,
      'Player_A_Frozen': Player_A_Frozen,
      'Player_B_Frozen': Player_B_Frozen,
      'ExitTeleport_A': ExitTeleport_A.toMap(),
      'ExitTeleport_B': ExitTeleport_B.toMap(),
    };
  }

  factory MazeMap.fromMap(Map<String, dynamic> map) {
    return MazeMap(
      mazeMap: List<List<Cube>>.from(
        (map['mazeMap'] as List<List<Cube>>)
            .map((x) => x.map((e) => Cube.fromMap(e as Map<String, dynamic>))),
      ),
      player_A: map['player_A'] != null
          ? Player.fromMap(map['player_A'] as Map<String, dynamic>)
          : null,
      player_B: map['player_B'] != null
          ? Player.fromMap(map['player_B'] as Map<String, dynamic>)
          : null,
      Player_A_Coord:
          Coordinates.fromMap(map['Player_A_Coord'] as Map<String, dynamic>),
      Player_B_Coord:
          Coordinates.fromMap(map['Player_B_Coord'] as Map<String, dynamic>),
      A_FrozenInstalled: map['A_FrozenInstalled'] as bool,
      B_FrozenInstalled: map['B_FrozenInstalled'] as bool,
      A_DoorInstalled: map['A_DoorInstalled'] as bool,
      B_DoorInstalled: map['B_DoorInstalled'] as bool,
      A_ExitInstalled: map['A_ExitInstalled'] as bool,
      B_ExitInstalled: map['B_ExitInstalled'] as bool,
      Player_A_Frozen: map['Player_A_Frozen'] as int,
      Player_B_Frozen: map['Player_B_Frozen'] as int,
      ExitTeleport_A:
          Coordinates.fromMap(map['ExitTeleport_A'] as Map<String, dynamic>),
      ExitTeleport_B:
          Coordinates.fromMap(map['ExitTeleport_B'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory MazeMap.fromJson(String source) =>
      MazeMap.fromMap(json.decode(source) as Map<String, dynamic>);
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

  Coordinates copyWith({
    bool? isInit,
    int? row,
    int? col,
  }) {
    return Coordinates(
      isInit: isInit ?? this.isInit,
      row: row ?? this.row,
      col: col ?? this.col,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'isInit': isInit,
      'row': row,
      'col': col,
    };
  }

  factory Coordinates.fromMap(Map<String, dynamic> map) {
    return Coordinates(
      isInit: map['isInit'] as bool,
      row: map['row'] as int,
      col: map['col'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory Coordinates.fromJson(String source) =>
      Coordinates.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Coordinates(isInit: $isInit, row: $row, col: $col)';

  @override
  bool operator ==(covariant Coordinates other) {
    if (identical(this, other)) return true;

    return other.isInit == isInit && other.row == row && other.col == col;
  }

  @override
  int get hashCode => isInit.hashCode ^ row.hashCode ^ col.hashCode;
}
