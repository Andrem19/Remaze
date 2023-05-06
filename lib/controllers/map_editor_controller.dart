import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remaze/controllers/routing/app_pages.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../TestData/editor_page.dart';
import '../TestData/test_map.dart';
import '../keys.dart';
import '../models/maze_map.dart';
import '../models/palyer.dart';

class MapEditorController extends GetxController {
  Rx<bool> isLoading = false.obs;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  // Stream maps = FirebaseFirestore.instance.collection('maps').snapshots();
  Stream<QuerySnapshot> maps =
      FirebaseFirestore.instance.collection('maps').snapshots();
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
      Keys.scaffoldMessengerKey.currentState!.showSnackBar(SnackBar(
        content: Text('Map saved'),
        backgroundColor: Color.fromARGB(255, 54, 244, 67),
      ));
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

  void loadMap(String name) async {
    isLoading.value = true;
    try {
      var map = await firebaseFirestore
          .collection('maps')
          .where('name', isEqualTo: name)
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
      _mazeMap.value = maze;
      Get.toNamed(Routes.MAP_EDITOR);
      isLoading.value = false;
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
      print(error.toString());
    }
  }

  void createNewMap() {
    _mazeMap = EditorPageMap.createStruct(TestData.createTestMap()).obs;
    Get.toNamed(Routes.MAP_EDITOR);
  }
}
