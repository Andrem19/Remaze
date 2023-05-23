import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remaze/controllers/routing/app_pages.dart';

import '../keys.dart';
import '../models/game_info.dart';
import '../models/maze_map.dart';
import 'main_game_controller.dart';

class BattleController extends GetxController {
  late Rx<MazeMap> mazeMap;
  late Stream<DocumentSnapshot<Map<String, dynamic>>> snapshots;
  late StreamSubscription<DocumentSnapshot<Map<String, dynamic>>> listner;
  Rx<String> gameId = ''.obs;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  MainGameController mainCtrl = Get.find<MainGameController>();
  Rx<GameInfo> gameInfo = GameInfo.createEmptyGameInfo(
          Get.find<MainGameController>().currentGameMap!)
      .obs;

  Rx<bool> showSkills = false.obs;

  Rx<bool> _frozenActivate = false.obs;
  Rx<bool> _teleportDoor = false.obs;
  Rx<bool> _teleportExit = false.obs;
  bool get frozenActivate => _frozenActivate.value;
  bool get teleportDoor => _teleportDoor.value;
  bool get teleportExit => _teleportExit.value;

  Rx<String> _yourRole = 'A'.obs;
  String get yourRole => _yourRole.value;
  Rx<String> textMessage = ''.obs;
  Rx<Direction> moveDirection = Direction.up.obs;
  var _timer;

  @override
  void onInit() {
    mainCtrl.changeStatusInGame(true);
    gameEngine();
    super.onInit();
  }

  @override
  void onClose() async {
    await PlayerNotReady();
    mainCtrl.deleteBattleGameInstant();
    mainCtrl.changeStatusInGame(false);
    if (_timer != null) {
      _timer.cancel();
      _timer = null;
    }
    listner.cancel();
    super.onClose();
  }

  void countFinal(String vinner) async {
    try {
      await firebaseFirestore
          .collection('gameBattle')
          .doc(gameId.value)
          .update({
        'vinner': vinner,
      });
      listner.cancel();

      Get.offNamed(Routes.END_GAME_SCREEN);
    } on FirebaseException catch (error) {
      Keys.scaffoldMessengerKey.currentState!.showSnackBar(SnackBar(
        content: Text(error.code),
        backgroundColor: Colors.red,
      ));
    } catch (error) {
      Keys.scaffoldMessengerKey.currentState!.showSnackBar(SnackBar(
        content: Text(error.toString()),
        backgroundColor: Colors.red,
      ));
    }
  }

  Future<void> PlayerNotReady() async {
    String vinner = '';
    var doc = await firebaseFirestore
        .collection('gameBattle')
        .doc(gameId.value)
        .get();
    if (doc.exists) {
      var data = doc.data();
      String gameVinner = data!['vinner'];
      if (gameVinner != yourRole) {
        vinner = yourRole == 'A' ? 'B' : 'A';
      } else {
        vinner = yourRole;
      }
    }
    if (yourRole == 'A') {
      await firebaseFirestore
          .collection('gameBattle')
          .doc(gameId.value)
          .update({'gameStatus': 'finish', 'Player_A_ready': false});
    } else {
      await firebaseFirestore
          .collection('gameBattle')
          .doc(gameId.value)
          .update({'gameStatus': 'finish', 'Player_B_ready': false});
    }
    mainCtrl.vinner = vinner;
  }

  Future<void> setUpVars() async {
    mazeMap = mainCtrl.currentGameMap!.obs;
    gameId.value = mainCtrl.currentmultiplayerGameId;
    _yourRole = mainCtrl.YourCurrentRole;
    if (yourRole == 'A') {
      mazeMap.value.countAndExecShaddow_A();
      changeState(mazeMap.value.getGameInfo(), yourRole);
    } else {
      mazeMap.value.reversePlus();
      mazeMap.value.countAndExecShaddow_B();
      changeState(
          GameInfo.reverseGameInfo(mazeMap.value.getGameInfo(), mazeMap.value),
          yourRole);
    }
    update();
  }

  void gameEngine() async {
    await setUpVars();
    userControl();
    snapshots = FirebaseFirestore.instance
        .collection('gameBattle')
        .doc(gameId.value)
        .snapshots();
    listner = snapshots.listen((data) {
      if (yourRole == 'A') {
        coordinatesOfEnemy_for_A(data['GameInfo_B']);
        mazeMap.value.countAndExecShaddow_A();
        String gameStatus = data['gameStatus'];
        bool b_used_teleport = data['B_used_teleport'];
        if (b_used_teleport) {
          mazeMap.value.ExitTeleport_A.isInit = false;
          mazeMap.value.message_A = 'Your anemy fell in your trap teleport';
        }
        if (gameStatus == 'finish') {
          A_finish_game();
        }
      } else if (yourRole == 'B') {
        coordinatesOfEnemy_for_B(data['GameInfo_A']);
        mazeMap.value.countAndExecShaddow_B();
        String gameStatus = data['gameStatus'];
        bool a_used_teleport = data['A_used_teleport'];
        if (a_used_teleport) {
          mazeMap.value.ExitTeleport_B.isInit = false;
          mazeMap.value.message_B = 'Your anemy fell in your trap teleport';
        }
        if (gameStatus == 'finish') {
          B_finish_game();
        }
      }
      update();
    });
  }

  void userControl() {
    _timer = Timer.periodic(Duration(milliseconds: 1000), (timer) {
      moveDirection.value = mainCtrl.moveDir;
      if (_yourRole.value == 'A') {
        bool aUsedTeleport = mazeMap.value.MovePlayer_A(moveDirection.value);
        mazeMap.value.countAndExecShaddow_A();
        textMessage.value = mazeMap.value.message_A;
        gameInfo.value = mazeMap.value.getGameInfo();
        if (aUsedTeleport) {
          changeUsedteleport();
        }
        changeState(gameInfo.value, yourRole);
        bool res = mazeMap.value.checkTheFinish_A();
        if (res) {
          countFinal('A');
          mainCtrl.vinner = 'A';
          if (_timer != null) {
            _timer.cancel();
            _timer = null;
          }
        }
      } else if (_yourRole.value == 'B') {
        bool bUsedTeleport = mazeMap.value.MovePlayer_B(moveDirection.value);
        mazeMap.value.countAndExecShaddow_B();
        textMessage.value = mazeMap.value.message_B;
        gameInfo.value = mazeMap.value.getGameInfo();
        if (bUsedTeleport) {
          changeUsedteleport();
        }
        changeState(
            GameInfo.reverseGameInfo(gameInfo.value, mazeMap.value), yourRole);
        bool res = mazeMap.value.checkTheFinish_B();
        if (res) {
          mainCtrl.vinner = 'B';
          countFinal('B');
          if (_timer != null) {
            _timer.cancel();
            _timer = null;
          }
        }
      }
      update();
    });
  }

  void changeUsedteleport() async {
    if (yourRole == 'A') {
      await firebaseFirestore
          .collection('gameBattle')
          .doc(gameId.value)
          .update({
        'A_used_teleport': true,
      });
    } else {
      await firebaseFirestore
          .collection('gameBattle')
          .doc(gameId.value)
          .update({
        'B_used_teleport': true,
      });
    }
  }

  void changeState(GameInfo gameInfo, String role) async {
    print(role);
    if (role == 'A') {
      await firebaseFirestore
          .collection('gameBattle')
          .doc(gameId.value)
          .update({
        'GameInfo_A': gameInfo.toJson(),
      });
    } else if (role == 'B') {
      await firebaseFirestore
          .collection('gameBattle')
          .doc(gameId.value)
          .update({
        'GameInfo_B': gameInfo.toJson(),
      });
    }
  }

  void coordinatesOfEnemy_for_A(String gameInfo_B) {
    var gameInfo = GameInfo.fromJson(gameInfo_B);
    mazeMap.value.Player_B_Coord = gameInfo.Player_B_Coord;
    mazeMap.value.Frozen_trap_B = gameInfo.Frozen_trap_B;
    mazeMap.value.DoorTeleport_B = gameInfo.DoorTeleport_B;
    mazeMap.value.ExitTeleport_B = gameInfo.ExitTeleport_B;
  }

  void coordinatesOfEnemy_for_B(String gameInfo_A) {
    var gameInfo =
        GameInfo.reverseGameInfo(GameInfo.fromJson(gameInfo_A), mazeMap.value);
    mazeMap.value.Player_A_Coord = gameInfo.Player_A_Coord;
    mazeMap.value.Frozen_trap_A = gameInfo.Frozen_trap_A;
    mazeMap.value.DoorTeleport_A = gameInfo.DoorTeleport_A;
    mazeMap.value.ExitTeleport_A = gameInfo.ExitTeleport_A;
  }

  void B_finish_game() async {
    await firebaseFirestore
        .collection('gameBattle')
        .doc(gameId.value)
        .update({'Player_B_ready': false});
    Get.offNamed(Routes.END_GAME_SCREEN);
  }

  void A_finish_game() async {
    await firebaseFirestore
        .collection('gameBattle')
        .doc(gameId.value)
        .update({'Player_A_ready': false});
    Get.offNamed(Routes.END_GAME_SCREEN);
  }

  void setUpFrozen() async {
    if (_yourRole == 'A') {
      mazeMap.value.instalFrozen_A();
    } else {
      mazeMap.value.instalFrozen_B();
    }
  }

  void setUpDoor() async {
    if (_yourRole == 'A') {
      mazeMap.value.instalDoor_A();
    } else {
      mazeMap.value.instalDoor_B();
    }
  }

  void setUpExit() async {
    if (_yourRole == 'A') {
      mazeMap.value.instalExit_A();
    } else {
      mazeMap.value.instalExit_B();
    }
  }
}
