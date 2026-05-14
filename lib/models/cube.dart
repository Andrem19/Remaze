import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Cube {
  int row;
  int col;
  bool wall;
  bool isShaddow;
  bool is_A_START;
  bool is_B_START;
  bool isCheeseHere;
  bool isPlayer_A_Here;
  bool isPlayer_B_Here;
  bool isFrozen_A_Here;
  bool isFrozen_B_Here;
  bool isTeleportDoor_A_Here;
  bool isTeleportExit_A_Here;
  bool isTeleportDoor_B_Here;
  bool isTeleportExit_B_Here;
  bool editAlowd;
  bool isBorderRight;
  bool isBorderDown;
  Cube({
    required this.row,
    required this.col,
    required this.wall,
    required this.isShaddow,
    required this.is_A_START,
    required this.is_B_START,
    required this.isCheeseHere,
    required this.isPlayer_A_Here,
    required this.isPlayer_B_Here,
    required this.isFrozen_A_Here,
    required this.isFrozen_B_Here,
    required this.isTeleportDoor_A_Here,
    required this.isTeleportExit_A_Here,
    required this.isTeleportDoor_B_Here,
    required this.isTeleportExit_B_Here,
    required this.editAlowd,
    required this.isBorderRight,
    required this.isBorderDown,
  }) {
    if (wall) {
      isPlayer_A_Here = false;
      isPlayer_B_Here = false;
    }
  }

  Cube copyWith({
    int? row,
    int? col,
    bool? wall,
    bool? isShaddow,
    bool? is_A_START,
    bool? is_B_START,
    bool? isCheeseHere,
    bool? isPlayer_A_Here,
    bool? isPlayer_B_Here,
    bool? isFrozen_A_Here,
    bool? isFrozen_B_Here,
    bool? isTeleportDoor_A_Here,
    bool? isTeleportExit_A_Here,
    bool? isTeleportDoor_B_Here,
    bool? isTeleportExit_B_Here,
    bool? editAlowd,
    bool? isBorderRight,
    bool? isBorderDown,
  }) {
    return Cube(
      row: row ?? this.row,
      col: col ?? this.col,
      wall: wall ?? this.wall,
      isShaddow: isShaddow ?? this.isShaddow,
      is_A_START: is_A_START ?? this.is_A_START,
      is_B_START: is_B_START ?? this.is_B_START,
      isCheeseHere: isCheeseHere ?? this.isCheeseHere,
      isPlayer_A_Here: isPlayer_A_Here ?? this.isPlayer_A_Here,
      isPlayer_B_Here: isPlayer_B_Here ?? this.isPlayer_B_Here,
      isFrozen_A_Here: isFrozen_A_Here ?? this.isFrozen_A_Here,
      isFrozen_B_Here: isFrozen_B_Here ?? this.isFrozen_B_Here,
      isTeleportDoor_A_Here:
          isTeleportDoor_A_Here ?? this.isTeleportDoor_A_Here,
      isTeleportExit_A_Here:
          isTeleportExit_A_Here ?? this.isTeleportExit_A_Here,
      isTeleportDoor_B_Here:
          isTeleportDoor_B_Here ?? this.isTeleportDoor_B_Here,
      isTeleportExit_B_Here:
          isTeleportExit_B_Here ?? this.isTeleportExit_B_Here,
      editAlowd: editAlowd ?? this.editAlowd,
      isBorderRight: isBorderRight ?? this.isBorderRight,
      isBorderDown: isBorderDown ?? this.isBorderDown,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'row': row,
      'col': col,
      'wall': wall,
      'isShaddow': isShaddow,
      'is_A_START': is_A_START,
      'is_B_START': is_B_START,
      'isCheeseHere': isCheeseHere,
      'isPlayer_A_Here': isPlayer_A_Here,
      'isPlayer_B_Here': isPlayer_B_Here,
      'isFrozen_A_Here': isFrozen_A_Here,
      'isFrozen_B_Here': isFrozen_B_Here,
      'isTeleportDoor_A_Here': isTeleportDoor_A_Here,
      'isTeleportExit_A_Here': isTeleportExit_A_Here,
      'isTeleportDoor_B_Here': isTeleportDoor_B_Here,
      'isTeleportExit_B_Here': isTeleportExit_B_Here,
      'editAlowd': editAlowd,
      'isBorderRight': isBorderRight,
      'isBorderDown': isBorderDown,
    };
  }

  factory Cube.fromMap(Map<String, dynamic> map) {
    return Cube(
      row: map['row'] as int,
      col: map['col'] as int,
      wall: map['wall'] as bool,
      isShaddow: map['isShaddow'] as bool,
      is_A_START: map['is_A_START'] as bool,
      is_B_START: map['is_B_START'] as bool,
      isCheeseHere: map['isCheeseHere'] as bool,
      isPlayer_A_Here: map['isPlayer_A_Here'] as bool,
      isPlayer_B_Here: map['isPlayer_B_Here'] as bool,
      isFrozen_A_Here: map['isFrozen_A_Here'] as bool,
      isFrozen_B_Here: map['isFrozen_B_Here'] as bool,
      isTeleportDoor_A_Here: map['isTeleportDoor_A_Here'] as bool,
      isTeleportExit_A_Here: map['isTeleportExit_A_Here'] as bool,
      isTeleportDoor_B_Here: map['isTeleportDoor_B_Here'] as bool,
      isTeleportExit_B_Here: map['isTeleportExit_B_Here'] as bool,
      editAlowd: map['editAlowd'] as bool,
      isBorderRight: map['isBorderRight'] as bool,
      isBorderDown: map['isBorderDown'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory Cube.fromJson(String source) =>
      Cube.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Cube(row: $row, col: $col, wall: $wall, is_A_START: $is_A_START, is_B_START: $is_B_START, isCheeseHere: $isCheeseHere, isPlayer_A_Here: $isPlayer_A_Here, isPlayer_B_Here: $isPlayer_B_Here, isFrozen_A_Here: $isFrozen_A_Here, isFrozen_B_Here: $isFrozen_B_Here, isTeleportDoor_A_Here: $isTeleportDoor_A_Here, isTeleportExit_A_Here: $isTeleportExit_A_Here, isTeleportDoor_B_Here: $isTeleportDoor_B_Here, isTeleportExit_B_Here: $isTeleportExit_B_Here, editAlowd: $editAlowd, isBorderRight: $isBorderRight, isBorderDown: $isBorderDown)';
  }

  @override
  bool operator ==(covariant Cube other) {
    if (identical(this, other)) return true;

    return other.row == row &&
        other.col == col &&
        other.wall == wall &&
        other.isShaddow == isShaddow &&
        other.is_A_START == is_A_START &&
        other.is_B_START == is_B_START &&
        other.isCheeseHere == isCheeseHere &&
        other.isPlayer_A_Here == isPlayer_A_Here &&
        other.isPlayer_B_Here == isPlayer_B_Here &&
        other.isFrozen_A_Here == isFrozen_A_Here &&
        other.isFrozen_B_Here == isFrozen_B_Here &&
        other.isTeleportDoor_A_Here == isTeleportDoor_A_Here &&
        other.isTeleportExit_A_Here == isTeleportExit_A_Here &&
        other.isTeleportDoor_B_Here == isTeleportDoor_B_Here &&
        other.isTeleportExit_B_Here == isTeleportExit_B_Here &&
        other.editAlowd == editAlowd &&
        other.isBorderRight == isBorderRight &&
        other.isBorderDown == isBorderDown;
  }

  @override
  int get hashCode {
    return row.hashCode ^
        col.hashCode ^
        wall.hashCode ^
        isShaddow.hashCode ^
        is_A_START.hashCode ^
        is_B_START.hashCode ^
        isCheeseHere.hashCode ^
        isPlayer_A_Here.hashCode ^
        isPlayer_B_Here.hashCode ^
        isFrozen_A_Here.hashCode ^
        isFrozen_B_Here.hashCode ^
        isTeleportDoor_A_Here.hashCode ^
        isTeleportExit_A_Here.hashCode ^
        isTeleportDoor_B_Here.hashCode ^
        isTeleportExit_B_Here.hashCode ^
        editAlowd.hashCode ^
        isBorderRight.hashCode ^
        isBorderDown.hashCode;
  }
}
