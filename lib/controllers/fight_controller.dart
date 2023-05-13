import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remaze/controllers/main_game_controller.dart';
import 'package:remaze/models/maze_map.dart';

import '../keys.dart';

class FightController extends GetxController {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  MainGameController mainCtrl = Get.find<MainGameController>();
  bool startButtonShow = false;
  var _timer;

  @override
  void onInit() {
    _adPlayerToQueueOrFindRival();
    super.onInit();
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
        'Player_B_name': mainCtrl.player.value.uid,
        'gameStatus': 'waiting'
      });
      startGameStream(playerList.docs[0].id);
    }
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }

  void startGameStream(String id) {
    var snapshots =
        FirebaseFirestore.instance.collection('gameList').doc(id).snapshots();
    snapshots.listen((snapshot) {
      if (snapshot.exists) {
        var data = snapshot.data();
        String gameStatus = data!['gameStatus'];
        if (gameStatus == 'waiting') {
          startButtonShow = true;
        }
        if (gameStatus == 'playing') {
          // Get.toNamed(page);
        }
      } else {
        print('Document does not exist');
      }
    });
  }

  Future<bool> _addPlayerToList() async {
    bool res = await chooseRandomMap();
    if (res) {
      try {
        var doc = await firebaseFirestore.collection('gameList').add({
          'MapName': mainCtrl.currentMapName,
          'Map_Id': mainCtrl.currentMapId,
          'Map': mainCtrl.currentGameMap?.toJson(),
          'Player_A_uid': mainCtrl.player.value.uid,
          'Player_A_Name': mainCtrl.player.value.userName,
          'Player_A_ready': false,
          'Player_B_uid': '',
          'Player_B_Name': '',
          'Player_B_ready': false,
          'gameStatus': 'searching',
        });
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
          content: Text(error.toString()),
          backgroundColor: Colors.red,
        ));
        return false;
      }
    }
    return false;
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
        MazeMap map = MazeMap.fromJson(maps.docs[randomInt]['map']);
        mainCtrl.currentMapName = maps.docs[randomInt]['name'];
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
        content: Text(error.toString()),
        backgroundColor: Colors.red,
      ));
    }
    return false;
  }
}
