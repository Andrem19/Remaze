import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remaze/controllers/main_game_controller.dart';
import 'package:remaze/controllers/routing/app_pages.dart';
import 'package:remaze/models/champions.dart';
import 'package:remaze/models/palyer.dart';

import '../keys.dart';
import '../models/cube.dart';
import '../models/leaders.dart';
import '../models/maze_map.dart';

class GameMenuController extends GetxController {
  bool isLoading = false;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  // late Rx<List<Map<String, int>>> listOfMapChampions;
  TextEditingController queryKey = TextEditingController(text: '');

  late Stream<QuerySnapshot> maps;
  RxList<Leaders> leaders = [Leaders(name: 'nobody', points: 0)].obs;
  RxList<Champions> mapChampions =
      [Champions(name: 'nobody', seconds: 10000)].obs;

  @override
  void onInit() {
    loadLeaders();
    maps = FirebaseFirestore.instance
        .collection('maps')
        .orderBy('rating', descending: false)
        .limit(10)
        .snapshots();
    super.onInit();
  }

  void search(String query) async {
    try {
      if (query == '') {
        maps = FirebaseFirestore.instance
            .collection('maps')
            .orderBy('rating', descending: false)
            .limit(10)
            .snapshots();
      } else {
        maps = FirebaseFirestore.instance
            .collection('maps')
            .where('name', isGreaterThanOrEqualTo: query)
            .where('name', isLessThan: query + 'z')
            .snapshots();
      }
      update();
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

  void loadLeaders() async {
    isLoading = true;
    try {
      var data = await firebaseFirestore
          .collection('users')
          .orderBy('points', descending: true)
          .limit(100)
          .get();
      if (data.docs.length > 0) {
        var docs = data.docs;
        leaders.value.clear();
        for (var i = 0; i < docs.length; i++) {
          var pl = Player.fromJson(docs[i]['user']);
          leaders.value
              .add(Leaders(name: pl.userName, points: docs[i]['points']));
        }
        update();
        isLoading = false;
      } else {
        Keys.scaffoldMessengerKey.currentState!.showSnackBar(SnackBar(
          content: Text('No leaders yet'),
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
  }

  void loadMapChampions(String mapId) async {
    isLoading = true;
    try {
      var data = await firebaseFirestore
          .collection('maps')
          .where('id', isEqualTo: mapId)
          .get();
      Map<String, dynamic> champions =
          data.docs[0]['champions'] as Map<String, dynamic>;
      var keysList = champions.keys.toList();
      var valuesList = champions.values.toList();
      mapChampions.value.clear();
      for (var i = 0; i < keysList.length; i++) {
        mapChampions.value
            .add(Champions(name: keysList[i], seconds: valuesList[i] as int));
      }
      mapChampions.value.sort((a, b) => a.seconds.compareTo(b.seconds));

      isLoading = false;
      update();
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

  void prepareQuestGame(String mapId) async {
    try {
      var map = await firebaseFirestore
          .collection('maps')
          .where('id', isEqualTo: mapId)
          .get();
      if (map.docs.isEmpty) {
        Keys.scaffoldMessengerKey.currentState!.showSnackBar(SnackBar(
          content: Text('Can\'t load the map'),
          backgroundColor: Colors.red,
        ));
      }
      if (!map.docs[0].exists) {
        Keys.scaffoldMessengerKey.currentState!.showSnackBar(SnackBar(
          content: Text('Cant\' load the map'),
          backgroundColor: Colors.red,
        ));
      }
      var mapJson = map.docs[0]['map'];

      var maze = MazeMap.fromJson(mapJson);
      maze.shaddowRadius = 5;
      var ctrMain = Get.find<MainGameController>();
      ctrMain.currentGameMap = installTeleportTrap(setFrozenTrap(maze));
      ctrMain.currentMapId = map.docs[0].id;
      Get.toNamed(Routes.GAME_ACT);
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

  MazeMap setFrozenTrap(MazeMap maze) {
    Coordinates coord = findRandomCoord(maze.mazeMap);
    maze.mazeMap[coord.row][coord.col].isFrozen_B_Here = true;
    coord = findRandomCoord(maze.mazeMap);
    maze.mazeMap[coord.row][coord.col].isFrozen_B_Here = true;
    return maze;
  }

  Coordinates findRandomCoord(List<List<Cube>> maze) {
    Coordinates randomCoord = getRandomCoordinates(maze.length, maze[0].length);
    if (maze[randomCoord.row][randomCoord.col].wall) {
      return findRandomCoord(maze);
    } else {
      return randomCoord;
    }
  }

  Coordinates getRandomCoordinates(int maxRow, int maxCol) {
    Random rnd = Random();
    int numRow = rnd.nextInt(maxRow);
    int numCol = rnd.nextInt(maxCol);
    return Coordinates(isInit: true, row: numRow, col: numCol);
  }

  MazeMap installTeleportTrap(MazeMap map) {
    var doorCoord = findRandomCoord(map.mazeMap);
    var exitCoord = findRandomCoord(map.mazeMap);
    map.mazeMap[doorCoord.row][doorCoord.col].isTeleportDoor_B_Here = true;
    map.mazeMap[doorCoord.row][doorCoord.col].isTeleportExit_B_Here = true;
    return map;
  }
}
