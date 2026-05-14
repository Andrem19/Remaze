// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'maze_map.dart';

class GameInfo {
  Coordinates Player_A_Coord;
  Coordinates Player_B_Coord;
  Coordinates DoorTeleport_A;
  Coordinates DoorTeleport_B;
  Coordinates Frozen_trap_A;
  Coordinates Frozen_trap_B;
  Coordinates ExitTeleport_A;
  Coordinates ExitTeleport_B;
  GameInfo({
    required this.Player_A_Coord,
    required this.Player_B_Coord,
    required this.DoorTeleport_A,
    required this.DoorTeleport_B,
    required this.Frozen_trap_A,
    required this.Frozen_trap_B,
    required this.ExitTeleport_A,
    required this.ExitTeleport_B,
  });

  static GameInfo createEmptyGameInfo(MazeMap map) {
    return GameInfo(
        Player_A_Coord:
            Coordinates(isInit: true, row: map.mazeMap.length - 1, col: 0),
        Player_B_Coord:
            Coordinates(isInit: true, row: 0, col: map.mazeMap[0].length - 1),
        DoorTeleport_A: Coordinates(isInit: false, row: 0, col: 0),
        DoorTeleport_B: Coordinates(isInit: false, row: 0, col: 0),
        Frozen_trap_A: Coordinates(isInit: false, row: 0, col: 0),
        Frozen_trap_B: Coordinates(isInit: false, row: 0, col: 0),
        ExitTeleport_A: Coordinates(isInit: false, row: 0, col: 0),
        ExitTeleport_B: Coordinates(isInit: false, row: 0, col: 0));
  }

  static GameInfo reverseGameInfo(GameInfo info, MazeMap map) {
    info.Player_B_Coord = Coordinates(
        isInit: info.Player_B_Coord.isInit,
        row: (map.mazeMap.length - 1) - info.Player_B_Coord.row,
        col: (map.mazeMap[0].length - 1) - info.Player_B_Coord.col);
    info.Player_A_Coord = Coordinates(
        isInit: info.Player_A_Coord.isInit,
        row: (map.mazeMap.length - 1) - info.Player_A_Coord.row,
        col: (map.mazeMap[0].length - 1) - info.Player_A_Coord.col);
    if (info.Frozen_trap_A.isInit) {
      info.Frozen_trap_A = Coordinates(
          isInit: info.Frozen_trap_A.isInit,
          row: (map.mazeMap.length - 1) - info.Frozen_trap_A.row,
          col: (map.mazeMap[0].length - 1) - info.Frozen_trap_A.col);
    }
    if (info.Frozen_trap_B.isInit) {
      info.Frozen_trap_B = Coordinates(
          isInit: info.Frozen_trap_B.isInit,
          row: (map.mazeMap.length - 1) - info.Frozen_trap_B.row,
          col: (map.mazeMap[0].length - 1) - info.Frozen_trap_B.col);
    }

    if (info.DoorTeleport_A.isInit) {
      info.DoorTeleport_A = Coordinates(
        isInit: info.DoorTeleport_A.isInit,
        row: (map.mazeMap.length - 1) - info.DoorTeleport_A.row,
        col: (map.mazeMap[0].length - 1) - info.DoorTeleport_A.col);
    }

    if (info.DoorTeleport_B.isInit) {
      info.DoorTeleport_B = Coordinates(
        isInit: info.DoorTeleport_B.isInit,
        row: (map.mazeMap.length - 1) - info.DoorTeleport_B.row,
        col: (map.mazeMap[0].length - 1) - info.DoorTeleport_B.col);
    }

    if (info.ExitTeleport_A.isInit) {
      info.ExitTeleport_A = Coordinates(
        isInit: info.ExitTeleport_A.isInit,
        row: (map.mazeMap.length - 1) - info.ExitTeleport_A.row,
        col: (map.mazeMap[0].length - 1) - info.ExitTeleport_A.col);
    }

    if (info.ExitTeleport_B.isInit) {
      info.ExitTeleport_B = Coordinates(
        isInit: info.ExitTeleport_B.isInit,
        row: (map.mazeMap.length - 1) - info.ExitTeleport_B.row,
        col: (map.mazeMap[0].length - 1) - info.ExitTeleport_B.col);
    }
    return info;
  }

  GameInfo copyWith({
    Coordinates? Player_A_Coord,
    Coordinates? Player_B_Coord,
    Coordinates? DoorTeleport_A,
    Coordinates? DoorTeleport_B,
    Coordinates? Frozen_trap_A,
    Coordinates? Frozen_trap_B,
    Coordinates? ExitTeleport_A,
    Coordinates? ExitTeleport_B,
  }) {
    return GameInfo(
      Player_A_Coord: Player_A_Coord ?? this.Player_A_Coord,
      Player_B_Coord: Player_B_Coord ?? this.Player_B_Coord,
      DoorTeleport_A: DoorTeleport_A ?? this.DoorTeleport_A,
      DoorTeleport_B: DoorTeleport_B ?? this.DoorTeleport_B,
      Frozen_trap_A: Frozen_trap_A ?? this.Frozen_trap_A,
      Frozen_trap_B: Frozen_trap_B ?? this.Frozen_trap_B,
      ExitTeleport_A: ExitTeleport_A ?? this.ExitTeleport_A,
      ExitTeleport_B: ExitTeleport_B ?? this.ExitTeleport_B,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'Player_A_Coord': Player_A_Coord.toMap(),
      'Player_B_Coord': Player_B_Coord.toMap(),
      'DoorTeleport_A': DoorTeleport_A.toMap(),
      'DoorTeleport_B': DoorTeleport_B.toMap(),
      'Frozen_trap_A': Frozen_trap_A.toMap(),
      'Frozen_trap_B': Frozen_trap_B.toMap(),
      'ExitTeleport_A': ExitTeleport_A.toMap(),
      'ExitTeleport_B': ExitTeleport_B.toMap(),
    };
  }

  factory GameInfo.fromMap(Map<String, dynamic> map) {
    return GameInfo(
      Player_A_Coord:
          Coordinates.fromMap(map['Player_A_Coord'] as Map<String, dynamic>),
      Player_B_Coord:
          Coordinates.fromMap(map['Player_B_Coord'] as Map<String, dynamic>),
      DoorTeleport_A:
          Coordinates.fromMap(map['DoorTeleport_A'] as Map<String, dynamic>),
      DoorTeleport_B:
          Coordinates.fromMap(map['DoorTeleport_B'] as Map<String, dynamic>),
      Frozen_trap_A:
          Coordinates.fromMap(map['Frozen_trap_A'] as Map<String, dynamic>),
      Frozen_trap_B:
          Coordinates.fromMap(map['Frozen_trap_B'] as Map<String, dynamic>),
      ExitTeleport_A:
          Coordinates.fromMap(map['ExitTeleport_A'] as Map<String, dynamic>),
      ExitTeleport_B:
          Coordinates.fromMap(map['ExitTeleport_B'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory GameInfo.fromJson(String source) =>
      GameInfo.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'GameInfo(Player_A_Coord: $Player_A_Coord, Player_B_Coord: $Player_B_Coord, DoorTeleport_A: $DoorTeleport_A, DoorTeleport_B: $DoorTeleport_B, Frozen_trap_A: $Frozen_trap_A, Frozen_trap_B: $Frozen_trap_B, ExitTeleport_A: $ExitTeleport_A, ExitTeleport_B: $ExitTeleport_B)';
  }

  @override
  bool operator ==(covariant GameInfo other) {
    if (identical(this, other)) return true;

    return other.Player_A_Coord == Player_A_Coord &&
        other.Player_B_Coord == Player_B_Coord &&
        other.DoorTeleport_A == DoorTeleport_A &&
        other.DoorTeleport_B == DoorTeleport_B &&
        other.Frozen_trap_A == Frozen_trap_A &&
        other.Frozen_trap_B == Frozen_trap_B &&
        other.ExitTeleport_A == ExitTeleport_A &&
        other.ExitTeleport_B == ExitTeleport_B;
  }

  @override
  int get hashCode {
    return Player_A_Coord.hashCode ^
        Player_B_Coord.hashCode ^
        DoorTeleport_A.hashCode ^
        DoorTeleport_B.hashCode ^
        Frozen_trap_A.hashCode ^
        Frozen_trap_B.hashCode ^
        ExitTeleport_A.hashCode ^
        ExitTeleport_B.hashCode;
  }
}
