// ignore_for_file: public_member_api_docs, sort_constructors_first
class Cube {
  int row;
  int col;
  bool wall;
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
}
