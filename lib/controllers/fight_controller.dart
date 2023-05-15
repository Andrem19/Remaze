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
import '../services/converter.dart';

class FightController extends GetxController {
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
    // await firebaseFirestore.collection('gameList').doc(gameId.value).delete();
    super.onClose();
  }

  void countFinal(String vinner) async {
    try {
      var doc = await firebaseFirestore
          .collection('gameList')
          .doc(gameId.value)
          .get();
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
      await firebaseFirestore.collection('gameList').doc(gameId.value).update({
        'gameStatus': 'finish',
      });
      // mainCtrl.refreshUserState();
      listner.cancel();
      Get.back();
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
      mazeMap = MazeMap.fromJson(data['Map']).obs;
      B_direction = Conv.strToDir(data['Pl_B_Direction']);
      B_frozen = data['Pl_B_Frozen'];
      B_door = data['Pl_B_Door'];
      B_exit = data['Pl_B_Exit'];
      if (_yourRole == 'B') {
        mazeMap.value.reverse();
        var gameStatus = data['gameStatus'];
        if (gameStatus == 'finish') {
          Get.back();
          listner.cancel();
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
        mazeMap.value.countAndExecShaddow_B();
        textMessage.value = mazeMap.value.message_B;
        updateDirection();
      }
      textMessage.value = mazeMap.value.message_A;
      update();
    });
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
