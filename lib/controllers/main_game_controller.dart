import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:remaze/models/palyer.dart';
import 'package:remaze/services/device_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../keys.dart';

class MainGameController extends GetxController {
  Rx<bool> showQR = false.obs;
  Rx<String> deviceId = ''.obs;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  var uuid = Uuid();
  late SharedPreferences pref;
  late Rx<String> isUserRegistrated = 'none'.obs;
  Rx<Player> player =
      Player(uid: 'uid', userName: 'userName', deviceId: '').obs;

  TextEditingController targetQrCode = TextEditingController();
  Rx<TextEditingController> userNameController = TextEditingController().obs;
  Rx<TextEditingController> migrationToken = TextEditingController().obs;

  @override
  void onInit() async {
    deviceId.value = await DeviceInfo.getDeviceId();
    print(deviceId.value);
    // DeviceInfo.printIps();
    pref = await SharedPreferences.getInstance();
    // await pref.remove('isUserRegistrated');
    // await pref.remove('user');
    await getUserDetails();
    super.onInit();
  }

  Future<void> getUserDetails() async {
    isUserRegistrated.value = pref.getString('isUserRegistrated') ?? 'none';
    if (isUserRegistrated.value == 'none') {
      registerGuidUser();
    } else if (isUserRegistrated.value == 'uid') {
      String user = pref.getString('user') ?? 'none';
      player = Player.fromJson(user).obs;
      try {
        var document = await firebaseFirestore
            .collection('users')
            .doc(player.value.uid)
            .get();
        var data = document.data();
        Player recivedPlayer = Player.fromJson(data!['user']);
        if (recivedPlayer.deviceId == deviceId.value) {
          player = recivedPlayer.obs;
          print('Auth complited');
        } else {
          registerGuidUser();
        }
        player.value.points = 783;
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
    setUserNameController();
    update();
  }

  void registerGuidUser() async {
    String uid = uuid.v4();
    String part = uid.substring(30);

    Player pl =
        Player(uid: uid, userName: 'Pl-$part', deviceId: deviceId.value);
    try {
      await firebaseFirestore.collection('users').doc(uid).set({
        'user': pl.toJson(),
      });
      player = pl.obs;
      pref.setString('isUserRegistrated', 'uid');
      pref.setString('user', pl.toJson());
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

  QrImage createQR() {
    return QrImage(
      data: player.value.uid,
      version: QrVersions.auto,
      size: 250.0,
    );
  }

  void changeQrShow() {
    showQR.value = !showQR.value;
    update();
  }

  void setUserNameController() {
    userNameController.value.text = player.value.userName;
    update();
  }

  void generateMigrationToken() async {
    print(player.value);
    String utoken = uuid.v4();
    player.value.migrationToken = utoken;
    await Clipboard.setData(ClipboardData(text: utoken));
    try {
      await firebaseFirestore.collection('users').doc(player.value.uid).set({
        'user': player.value.toJson(),
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
    Keys.scaffoldMessengerKey.currentState!.showSnackBar(SnackBar(
      content: Text('Token was copied'),
      backgroundColor: Color.fromARGB(255, 54, 244, 67),
    ));
    update();
  }
}
