import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remaze/controllers/routing/app_pages.dart';
import 'package:remaze/models/game_info.dart';

import '../keys.dart';
import '../models/maze_map.dart';
import 'main_game_controller.dart';

class SearchRivalController extends GetxController {
  String gameId = '';
  RxString gameStatus = 'searching...'.obs;
  RxString nameOfMap = 'searching...'.obs;
  MainGameController mainCtrl = Get.find<MainGameController>();
  Rx<bool> startButtonShow = false.obs;
  late Stream<DocumentSnapshot<Map<String, dynamic>>> snapshots;
  late StreamSubscription<DocumentSnapshot<Map<String, dynamic>>> listner;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    _adPlayerToQueueOrFindRival();
    super.onInit();
  }

  @override
  void onClose() async {
    await chekIfNeedToDelete();
    listner.cancel();
    super.onClose();
  }

  void _adPlayerToQueueOrFindRival() async {
    var playerList = await FirebaseFirestore.instance
        .collection('gameList')
        .where('gameStatus', isEqualTo: 'searching')
        .get();

    if (playerList.docs.length < 1) {
      _addPlayerToList();
    } else {
      await FirebaseFirestore.instance
          .collection('gameList')
          .doc(playerList.docs[0].id)
          .update({
        'Player_B_uid': mainCtrl.player.value.uid,
        'Player_B_Name': mainCtrl.player.value.uid,
        'gameStatus': 'waiting'
      });
      var data = playerList.docs[0].data();

      mainCtrl.currentMapId = data['Map_Id'];
      var maps = await FirebaseFirestore.instance
          .collection('maps')
          .where('id', isEqualTo: mainCtrl.currentMapId)
          .get();
      if (maps.docs.length > 0) {
        var data = maps.docs[0].data();
        mainCtrl.currentGameMap = MazeMap.fromJson(data['map']);
        prepareMapToGame();
      }
      mainCtrl.currentmultiplayerGameId = playerList.docs[0].id;
      mainCtrl.currentMapName = data['MapName'];
      mainCtrl.YourCurrentRole.value = 'B';
      startGameStream(playerList.docs[0].id);
    }
  }

  void startGameStream(String id) async {

    mainCtrl.currentmultiplayerGameId = id;
    snapshots =
        FirebaseFirestore.instance.collection('gameList').doc(id).snapshots();
    listner = snapshots.listen((snapshot) {

      if (snapshot.exists) {

        var data = snapshot.data();

        gameStatus.value = data!['gameStatus'];
        if (gameStatus.value == 'waiting') {

          startButtonShow.value = true;
          update();
        }
        if (gameStatus.value == 'playing') {

          gameStatus.value = 'game';
          Get.offNamed(Routes.ACT_PLAYER_ACREEN);
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
          .collection('gameList')
          .doc(mainCtrl.currentmultiplayerGameId)
          .get();
      if (mainCtrl.YourCurrentRole.value == 'A') {
        await firebaseFirestore
            .collection('gameList')
            .doc(mainCtrl.currentmultiplayerGameId)
            .update({
          'Player_A_ready': true,
        });
        if (doc.data()!['Player_B_ready'] == true) {
          await firebaseFirestore
              .collection('gameList')
              .doc(mainCtrl.currentmultiplayerGameId)
              .update({
            'gameStatus': 'playing',
          });
          // Get.toNamed(Routes.ACT_PLAYER_ACREEN);
        }
      } else if (mainCtrl.YourCurrentRole.value == 'B') {
        await firebaseFirestore
            .collection('gameList')
            .doc(mainCtrl.currentmultiplayerGameId)
            .update({
          'Player_B_ready': true,
        });
        if (doc.data()!['Player_A_ready'] == true) {
          await firebaseFirestore
              .collection('gameList')
              .doc(mainCtrl.currentmultiplayerGameId)
              .update({
            'gameStatus': 'playing',
          });
          // Get.toNamed(Routes.ACT_PLAYER_ACREEN);
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

  Future<bool> _addPlayerToList() async {
    bool res = await chooseRandomMap();
    if (res) {
      try {
        var doc = await firebaseFirestore.collection('gameList').add({
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
        startGameStream(doc.id);
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

  Future<void> chekIfNeedToDelete() async {
    if (gameId != '') {
      var doc =
          await firebaseFirestore.collection('gameList').doc(gameId).get();
      if (doc.exists) {
        var data = doc.data();
        String status = data!['gameStatus'] as String;
        if (status == 'searching' || status == 'waiting') {
          await firebaseFirestore.collection('gameList').doc(gameId).delete();
        }
      }
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
