import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remaze/controllers/main_game_controller.dart';
import 'package:remaze/controllers/routing/app_pages.dart';
import 'package:remaze/models/maze_map.dart';
import 'package:remaze/views/game/multiplayer_game_act.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:isolate';

import '../keys.dart';
import '../models/game_info.dart';
import '../services/converter.dart';

class FightController extends GetxController {
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
  late Direction B_direction;
  late bool B_frozen;
  late bool B_door;
  late bool B_exit;
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
    gameEngine();
    super.onInit();
  }

  @override
  void onClose() async {
    if (_timer != null) {
      _timer.cancel();
      _timer = null;
    }
    listner.cancel();
    super.onClose();
  }

  void countFinal(String vinner) async {
    try {
      var doc = await firebaseFirestore
          .collection('gameList')
          .doc(gameId.value)
          .get();
      await firebaseFirestore.collection('gameList').doc(gameId.value).update({
        'vinner': vinner,
      });
      var data = doc.data();

      String uidPlayer_A = data!['Player_A_uid'] as String;
      String uidPlayer_B = data['Player_B_uid'] as String;

      var userA =
          await firebaseFirestore.collection('users').doc(uidPlayer_A).get();
      var userB =
          await firebaseFirestore.collection('users').doc(uidPlayer_B).get();
      var userAData = userA.data();
      int pointsA = userAData!['points'] as int;
      int resPointA = vinner == 'A' ? pointsA + 2 : pointsA - 1;
      await firebaseFirestore.collection('users').doc(uidPlayer_A).update({
        'points': resPointA,
      });
      var userBData = userB.data();
      int pointsB = userBData!['points'] as int;
      int resPointB = vinner == 'B' ? pointsB + 2 : pointsB - 1;
      await firebaseFirestore.collection('users').doc(uidPlayer_B).update({
        'points': resPointB,
      });
      mainCtrl.refreshUserState();
      listner.cancel();
      if (yourRole == 'A') {
        await firebaseFirestore
            .collection('gameList')
            .doc(gameId.value)
            .update({'gameStatus': 'finish', 'Player_A_ready': false});
      } else {
        await firebaseFirestore
            .collection('gameList')
            .doc(gameId.value)
            .update({'gameStatus': 'finish', 'Player_B_ready': false});
      }
      Get.offNamed(Routes.FINISH_PAGE);
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
        .collection('gameList')
        .doc(gameId.value)
        .snapshots();
    listner = snapshots.listen((data) {
      if (yourRole == 'A') {
        // gameInfo = GameInfo.fromJson(data['GameInfo_A']).obs;
        // mazeMap.value.fromGameInfo(gameInfo.value);
        coordinatesOfEnemy_for_A(data['GameInfo_B']);
        mazeMap.value.countAndExecShaddow_A();
        String gameStatus = data['gameStatus'];
        if (gameStatus == 'finish') {
          A_finish_game();
        }
      } else if (yourRole == 'B') {
        // gameInfo = GameInfo.fromJson(data['GameInfo_B']).obs;
        // mazeMap.value.fromGameInfo(GameInfo.reverseGameInfo(gameInfo.value, mazeMap.value));
        coordinatesOfEnemy_for_B(data['GameInfo_A']);
        mazeMap.value.countAndExecShaddow_B();
        String gameStatus = data['gameStatus'];
        if (gameStatus == 'finish') {
          B_finish_game();
        }
      }
      update();
    });
  }

  void userControl() {
    _timer = Timer.periodic(Duration(milliseconds: 1000), (timer) {
      if (_yourRole.value == 'A') {
        mazeMap.value.MovePlayer_A(moveDirection.value);
        mazeMap.value.countAndExecShaddow_A();
        textMessage.value = mazeMap.value.message_A;
        gameInfo.value = mazeMap.value.getGameInfo();
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
        mazeMap.value.MovePlayer_B(moveDirection.value);
        mazeMap.value.countAndExecShaddow_B();
        textMessage.value = mazeMap.value.message_B;
        gameInfo.value = mazeMap.value.getGameInfo();
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

  void changeState(GameInfo gameInfo, String role) async {
    print(role);
    if (role == 'A') {
      await firebaseFirestore.collection('gameList').doc(gameId.value).update({
        'GameInfo_A': gameInfo.toJson(),
      });
    } else if (role == 'B') {
      await firebaseFirestore.collection('gameList').doc(gameId.value).update({
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
        .collection('gameList')
        .doc(gameId.value)
        .update({'Player_B_ready': false});
    Get.offNamed(Routes.FINISH_PAGE);
  }

  void A_finish_game() async {
    await firebaseFirestore
        .collection('gameList')
        .doc(gameId.value)
        .update({'Player_A_ready': false});
    Get.offNamed(Routes.FINISH_PAGE);
  }

  void updateDirection() async {
    await firebaseFirestore.collection('gameList').doc(gameId.value).update({
      'Pl_B_Direction': Conv.dirToStr(moveDirection.value),
    });
  }

  void setUpFrozen() async {
    if (_yourRole == 'A') {
      mazeMap.value.instalFrozen_A();
    } else {
      await firebaseFirestore.collection('gameList').doc(gameId.value).update({
        'Pl_B_Frozen': true,
      });
    }
  }

  void setUpDoor() async {
    if (_yourRole == 'A') {
      mazeMap.value.instalDoor_A();
    } else {
      await firebaseFirestore.collection('gameList').doc(gameId.value).update({
        'Pl_B_Door': true,
      });
    }
  }

  void setUpExit() async {
    if (_yourRole == 'A') {
      mazeMap.value.instalExit_A();
    } else {
      await firebaseFirestore.collection('gameList').doc(gameId.value).update({
        'Pl_B_Exit': true,
      });
    }
  }
}
