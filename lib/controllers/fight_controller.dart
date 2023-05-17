import 'dart:async';
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
  late Rx<GameInfo> gameInfo;
  late Rx<MazeMap> mazeMap;
  late Stream<DocumentSnapshot<Map<String, dynamic>>> snapshots;
  late StreamSubscription<DocumentSnapshot<Map<String, dynamic>>> listner;
  Rx<String> gameId = ''.obs;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  MainGameController mainCtrl = Get.find<MainGameController>();

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
      if (vinner == 'A') {
        mainCtrl.isVinner = true;
      } else {
        mainCtrl.isVinner = false;
      }

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
      await firebaseFirestore
          .collection('gameList')
          .doc(gameId.value)
          .update({'gameStatus': 'finish', 'Player_A_ready': false});
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

  void setUpVars() {
    mazeMap = mainCtrl.currentGameMap!.obs;
    gameId.value = mainCtrl.currentmultiplayerGameId;
    _yourRole = mainCtrl.YourCurrentRole;
    if (yourRole == 'A') {
      moveDirection.value = Direction.up;
      mazeMap.value.countAndExecShaddow_A();
    } else {
      mazeMap.value.countAndExecShaddow_B();
      moveDirection.value = Direction.down;
    }
  }

  // void exit() async {
  //   SharedPreferences pref = await SharedPreferences.getInstance();
  //   String uid = pref.getString('uid') ?? 'none';
  //   var document = await firebaseFirestore.collection('users').doc(uid).get();
  //   var me = document.data();
  //   mainCtrl.points.value = me!['points'] as int;
  //   Get.back();
  //   listner.cancel();
  // }

  void gameEngine() async {
    setUpVars();
    snapshots = FirebaseFirestore.instance
        .collection('gameList')
        .doc(gameId.value)
        .snapshots();
    listner = snapshots.listen((data) {
      if (yourRole == 'A') {
        gameInfo = GameInfo.fromJson(data['GameInfo_A']).obs;
        mazeMap.value.fromGameInfo(gameInfo.value);
        mazeMap.value.countAndExecShaddow_A();
      } else if (yourRole == 'B') {
        gameInfo = GameInfo.fromJson(data['GameInfo_B']).obs;
        mazeMap.value.fromGameInfo(gameInfo.value);
        mazeMap.value.countAndExecShaddow_B();
        mazeMap.value.reverse();
        //======================================= продолжить отсюда
        String gameStatus = data['gameStatus'];
        if (gameStatus == 'finish') {
          String vinner = data['vinner'];
          if (vinner == 'B') {
            mainCtrl.isVinner = true;
          } else {
            mainCtrl.isVinner = false;
          }
          mainCtrl.refreshUserState();
          listner.cancel();
          B_finish_game();
        }
      }
    });
    // Isolate.spawn();
    _timer = Timer.periodic(Duration(milliseconds: 1000), (timer) {
      if (_yourRole.value == 'A') {
        mazeMap.value.MovePlayer_A(moveDirection.value);
        mazeMap.value.countAndExecShaddow_A();
        textMessage.value = mazeMap.value.message_A;
        mazeMap.value.MovePlayer_B(B_direction);
        String res = mazeMap.value.checkTheFinish();
        if (res == 'A' || res == 'B') {
          countFinal(res);
          if (_timer != null) {
            _timer.cancel();
            _timer = null;
          }
          // Get.toNamed(Routes.GENERAL_MENU);
        }
        mazeMap.value.checkTheFinish();
        if (B_frozen) {
          mazeMap.value.instalFrozen_B();
        }
        if (B_door) {
          mazeMap.value.instalDoor_B();
        }
        if (B_exit) {
          mazeMap.value.instalExit_B();
        }
        firebaseFirestore.collection('gameList').doc(gameId.value).update({
          'Map': mazeMap.value.toJson(),
        });
      } else if (_yourRole.value == 'B') {
        textMessage.value = mazeMap.value.message_B;
        updateDirection();
      }
      textMessage.value = mazeMap.value.message_A;
      update();
    });
  }

  void B_finish_game() async {
    await firebaseFirestore
        .collection('gameList')
        .doc(gameId.value)
        .update({'Player_B_ready': false});
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
