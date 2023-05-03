import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:remaze/models/palyer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MainGameController extends GetxController {
  Rx<bool> showQR = false.obs;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  late SharedPreferences pref;
  late Rx<String> isUserRegistrated = 'none'.obs;
  Rx<Player> player = Player(uid: 'uid', userName: 'userName').obs;

  @override
  void onInit() async {
    pref = await SharedPreferences.getInstance();
    // await pref.remove('isUserRegistrated');
    // await pref.remove('user');
    await getUserDetails();
    super.onInit();
  }

  Future<void> getUserDetails() async {
    // FirebaseAuth.instance.authStateChanges();
    isUserRegistrated.value = pref.getString('isUserRegistrated') ?? 'none';
    if (isUserRegistrated.value == 'none') {
      registerGuidUser();
    } else if (isUserRegistrated.value == 'uid') {
      String user = pref.getString('user') ?? 'none';
      player = Player.fromJson(user).obs;

      var document = await firebaseFirestore
          .collection('users')
          .doc(player.value.uid)
          .get();
      var data = document.data();

      player = Player.fromJson(data!['user']).obs;
      player.value.points = 783;
      update();
    }
    update();
  }

  void registerGuidUser() async {
    var uuid = Uuid();
    String uid = uuid.v4();
    String part = uid.substring(30);

    Player pl = Player(uid: uid, userName: 'Pl-$part');

    await firebaseFirestore.collection('users').doc(uid).set({
      'user': pl.toJson(),
    });
    player = pl.obs;
    pref.setString('isUserRegistrated', 'uid');
    pref.setString('user', pl.toJson());
    update();
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
}
