import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remaze/controllers/main_game_controller.dart';
import 'package:remaze/controllers/routing/app_pages.dart';

import '../keys.dart';
import '../models/cube.dart';
import '../models/maze_map.dart';

class GameMenuController extends GetxController {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  void prepareQuestGame(String mapName) async {
    try {
      var map = await firebaseFirestore
          .collection('maps')
          .where('name', isEqualTo: mapName)
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
      ctrMain.currentGameMap = setFrozenTrap(maze);
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
    Coordinates coord = findRandomFrozen(maze.mazeMap);
    maze.mazeMap[coord.row][coord.col].isFrozen_B_Here = true;
    coord = findRandomFrozen(maze.mazeMap);
    maze.mazeMap[coord.row][coord.col].isFrozen_B_Here = true;
    return maze;
  }

  Coordinates findRandomFrozen(List<List<Cube>> maze) {
    Coordinates randomCoord = getRandomCoordinates(maze.length, maze[0].length);
    if (maze[randomCoord.row][randomCoord.col].wall) {
      return findRandomFrozen(maze);
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
}
