import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../TestData/editor_page.dart';
import '../TestData/test_map.dart';
import '../keys.dart';
import '../models/maze_map.dart';
import '../models/palyer.dart';

class MapEditorController extends GetxController {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  late SharedPreferences pref;
  var uuid = Uuid();

  late Rx<MazeMap> _mazeMap =
      EditorPageMap.createStruct(TestData.createTestMap()).obs;
  MazeMap get mazeMap => _mazeMap.value;

  @override
  void onInit() async {
    pref = await SharedPreferences.getInstance();
    super.onInit();
  }

  void changeWall(int row, int col) {
    if (_mazeMap.value.mazeMap[row][col].editAlowd) {
      _mazeMap.value.mazeMap[row][col].wall =
          !_mazeMap.value.mazeMap[row][col].wall;

      int mirrorRow = _mazeMap.value.mazeMap.length - row - 1;
      int mirrorCol = _mazeMap.value.mazeMap[0].length - col - 1;
      _mazeMap.value.mazeMap[mirrorRow][mirrorCol].wall =
          _mazeMap.value.mazeMap[row][col].wall;
    }
    update();
  }

  void saveMap() async {
    String user = pref.getString('user') ?? 'none';
    Player? pl;
    if (user != 'none') {
      pl = Player.fromJson(user);
    }
    String name = uuid.v4();
    print(mazeMap.toMap());
    try {
      await firebaseFirestore.collection('maps').add({
        'name': name,
        'author': pl!.uid,
        'map': mazeMap.toJson(),
      });
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
}
