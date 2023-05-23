import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remaze/controllers/routing/app_pages.dart';

import '../keys.dart';
import '../models/game_info.dart';
import '../models/maze_map.dart';
import 'main_game_controller.dart';

class InviteToBattle extends GetxController {
  MainGameController mainCtrl = Get.find<MainGameController>();
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  String gameId = '';
  RxString gameStatus = 'searching...'.obs;
  RxString nameOfMap = 'searching...'.obs;
  Rx<bool> startButtonShow = false.obs;
  late Stream<DocumentSnapshot<Map<String, dynamic>>> snapshots;
  late StreamSubscription<DocumentSnapshot<Map<String, dynamic>>> listner;

  @override
  void onClose() {
    listner.cancel();
    super.onClose();
  }

  @override
  void onInit() async {
    if (mainCtrl.YourCurrentRole.value == 'A') {
      await _addPlayerToList();

      await firebaseFirestore
          .collection('users')
          .doc(mainCtrl.playerWhoIInvite_ID)
          .update({
        'isAnybodyAscMe': true,
        'whoInviteMeToPlay': mainCtrl.player.value.userName,
        'theGameIdInviteMe': mainCtrl.currentmultiplayerGameId
      });
    } else if (mainCtrl.YourCurrentRole.value == 'B') {
      startGameStream();
    }
    super.onInit();
  }

  Future<bool> _addPlayerToList() async {
    bool res = await chooseRandomMap();

    if (res) {
      try {
        var doc = await firebaseFirestore.collection('gameBattle').add({
          'IcantPlay': false,
          'MapName': mainCtrl.currentMapName,
          'Map_Id': mainCtrl.currentMapId,
          'Player_A_uid': mainCtrl.player.value.uid,
          'Player_A_Name': mainCtrl.player.value.userName,
          'Player_A_ready': false,
          'Player_B_uid': '',
          'Player_B_Name': '',
          'Player_B_ready': false,
          'B_used_teleport': false,
          'A_used_teleport': false,
          'GameInfo_A':
              GameInfo.createEmptyGameInfo(mainCtrl.currentGameMap!).toJson(),
          'GameInfo_B':
              GameInfo.createEmptyGameInfo(mainCtrl.currentGameMap!).toJson(),
          'vinner': '',
          'gameStatus': 'searching',
          'date': DateTime.now(),
        });
        mainCtrl.YourCurrentRole.value = 'A';
        nameOfMap.value = mainCtrl.currentMapName ?? '';
        gameId = doc.id;
        mainCtrl.currentmultiplayerGameId = doc.id;
        startGameStream();
        return true;
      } on FirebaseException catch (error) {
        Keys.scaffoldMessengerKey.currentState!.showSnackBar(SnackBar(
          content: Text(error.code),
          backgroundColor: Colors.red,
        ));
        return false;
      } catch (error) {
        Keys.scaffoldMessengerKey.currentState!.showSnackBar(SnackBar(
          content: Text('2: ${error.toString()}'),
          backgroundColor: Colors.red,
        ));
        return false;
      }
    }
    return false;
  }

  void startGameStream() async {
    snapshots = FirebaseFirestore.instance
        .collection('gameBattle')
        .doc(mainCtrl.currentmultiplayerGameId)
        .snapshots();
    listner = snapshots.listen((snapshot) {
      if (snapshot.exists) {
        var data = snapshot.data();
        gameStatus.value = data!['gameStatus'];
        bool IcantPlay = data['IcantPlay'];
        if (IcantPlay) {
          listner.cancel();
          mainCtrl.changeStatusInGame(false);
          firebaseFirestore
              .collection('gameBattle')
              .doc(mainCtrl.currentmultiplayerGameId)
              .delete();
          Get.offNamed(Routes.GENERAL_MENU);
          Keys.scaffoldMessengerKey.currentState!.showSnackBar(SnackBar(
            content: Text('Player refuses to play'),
            backgroundColor: Colors.red,
          ));
        }
        if (gameStatus.value == 'waiting') {
          startButtonShow.value = true;
          update();
        }
        if (gameStatus.value == 'playing') {
          gameStatus.value = 'game';
          Get.offNamed(Routes.FIGHT_BATTLE_ACT);
          firebaseFirestore
              .collection('gameList')
              .doc(mainCtrl.currentmultiplayerGameId)
              .update({
            'gameStatus': 'game',
          });
        }
      } else {
        print('Document does not exist');
      }
    });
    update();
  }

  void toPlay() async {
    try {
      var doc = await firebaseFirestore
          .collection('gameBattle')
          .doc(mainCtrl.currentmultiplayerGameId)
          .get();
      if (mainCtrl.YourCurrentRole.value == 'A') {
        await firebaseFirestore
            .collection('gameBattle')
            .doc(mainCtrl.currentmultiplayerGameId)
            .update({
          'Player_A_ready': true,
        });
        if (doc.data()!['Player_B_ready'] == true) {
          await firebaseFirestore
              .collection('gameBattle')
              .doc(mainCtrl.currentmultiplayerGameId)
              .update({
            'gameStatus': 'playing',
          });
        }
      } else if (mainCtrl.YourCurrentRole.value == 'B') {
        await firebaseFirestore
            .collection('gameBattle')
            .doc(mainCtrl.currentmultiplayerGameId)
            .update({
          'Player_B_ready': true,
        });
        if (doc.data()!['Player_A_ready'] == true) {
          await firebaseFirestore
              .collection('gameBattle')
              .doc(mainCtrl.currentmultiplayerGameId)
              .update({
            'gameStatus': 'playing',
          });
        }
      }
    } on FirebaseException catch (error) {
      Keys.scaffoldMessengerKey.currentState!.showSnackBar(SnackBar(
        content: Text(error.code),
        backgroundColor: Colors.red,
      ));
    } catch (error) {
      Keys.scaffoldMessengerKey.currentState!.showSnackBar(SnackBar(
        content: Text('3: ${error.toString()}'),
        backgroundColor: Colors.red,
      ));
    }
  }

  Future<bool> chooseRandomMap() async {
    try {
      var maps = await FirebaseFirestore.instance
          .collection('maps')
          .orderBy('rating', descending: false)
          .limit(10)
          .get();
      int randomInt = Random().nextInt(maps.docs.length);

      if (maps.docs[randomInt].exists) {
        mainCtrl.currentMapId = maps.docs[randomInt]['id'];

        mainCtrl.currentGameMap = MazeMap.fromJson(maps.docs[randomInt]['map']);
        mainCtrl.currentMapName = maps.docs[randomInt]['name'];

        prepareMapToGame();
        return true;
      } else {
        Keys.scaffoldMessengerKey.currentState!.showSnackBar(SnackBar(
          content: Text('Something went wrong'),
          backgroundColor: Colors.red,
        ));
      }
    } on FirebaseException catch (error) {
      Keys.scaffoldMessengerKey.currentState!.showSnackBar(SnackBar(
        content: Text(error.code),
        backgroundColor: Colors.red,
      ));
    } catch (error) {
      Keys.scaffoldMessengerKey.currentState!.showSnackBar(SnackBar(
        content: Text('1: ${error.toString()}'),
        backgroundColor: Colors.red,
      ));
    }
    return false;
  }

  void prepareMapToGame() {
    mainCtrl.currentGameMap!.shaddowRadius = 5;
  }
}
