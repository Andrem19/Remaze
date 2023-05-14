import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:remaze/models/maze_map.dart';
import 'package:remaze/models/palyer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../AppOpenAdManager.dart';
import '../keys.dart';

class MainGameController extends GetxController with WidgetsBindingObserver {
  // Stream documentStream = FirebaseFirestore.instance.collection('users').doc('d97e021d-bcde-448b-aa4b-bd4873e09973').snapshots();
  MazeMap? currentGameMap;
  String? currentMapId;
  String? currentMapName;
  String currentmultiplayerGameId = '';
  Rx<String> secretToken = ''.obs;
  Rx<String> YourCurrentRole = 'A'.obs;
  Rx<bool> showQR = false.obs;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  var uuid = Uuid();
  late SharedPreferences pref;
  Rx<Player> player = Player(uid: 'uid', userName: 'userName').obs;
  Rx<int> points = 0.obs;

  TextEditingController targetQrCode = TextEditingController();
  Rx<TextEditingController> userNameController = TextEditingController().obs;
  Rx<String> migrationTokenGen = ''.obs;
  Rx<TextEditingController> migrationToken = TextEditingController().obs;
  TextEditingController playerSearch = TextEditingController(text: '');

  AppOpenAdManager appOpenAdManager = AppOpenAdManager();
  bool isPaused = false;

  @override
  void onInit() async {
    if (!kIsWeb) {
      appOpenAdManager.loadAd();
      WidgetsBinding.instance.addObserver(this);
    }
    pref = await SharedPreferences.getInstance();
    // await pref.remove('secretToken');
    // await pref.remove('user');
    await authenticate();
    super.onInit();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
      isPaused = true;
    }
    if (state == AppLifecycleState.resumed && isPaused) {
      print("RESUME -------");
      appOpenAdManager.showAdIfAvailable();
      isPaused = false;
    }
  }

  Future<void> authenticate() async {
    secretToken.value = pref.getString('secretToken') ?? 'none';
    if (secretToken.value == 'none') {
      await registerNewUser();
    } else if (secretToken.value != 'none') {
      await checkUserAuth();
    }
    setUserNameController();
  }

  Future<void> checkUserAuth() async {
    String uid = pref.getString('uid') ?? 'none';
    if (uid == 'none') {
      registerNewUser();
    }
    try {
      var document = await firebaseFirestore.collection('users').doc(uid).get();
      if (!document.exists) {
        registerNewUser();
      }
      var data = document.data();
      Player recivedPlayer = Player.fromJson(data!['user']);
      String token = data['secretToken'];
      if (secretToken.value != token) {
        registerNewUser();
      }
      points.value = data['points'];
      player.value = recivedPlayer;
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

  Future<void> registerNewUser() async {
    String uid = uuid.v4();
    String part = uid.substring(30);
    String secrTok = uuid.v4();

    Player pl = Player(uid: uid, userName: 'Pl-$part');
    try {
      await firebaseFirestore.collection('users').doc(uid).set({
        'user': pl.toJson(),
        'secretToken': secrTok,
        'migrationToken': '',
        'points': 0,
      });
      player = pl.obs;
      pref.setString('secretToken', secrTok);
      pref.setString('uid', uid);
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
      data: player.value.userName,
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
    await checkUserAuth();
    String utoken = uuid.v4();

    await Clipboard.setData(ClipboardData(text: utoken));
    migrationTokenGen.value = utoken;
    try {
      await firebaseFirestore.collection('users').doc(player.value.uid).update({
        'migrationToken': utoken,
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

  void updateName() async {
    await checkUserAuth();
    try {
      player.value.userName = userNameController.value.text;

      await firebaseFirestore.collection('users').doc(player.value.uid).update({
        'user': player.value.toJson(),
      });
      pref.setString('user', player.value.toJson());
      update();
      Keys.scaffoldMessengerKey.currentState!.showSnackBar(SnackBar(
        content: Text('Name updated'),
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

  void migrate() async {
    try {
      var document = await firebaseFirestore
          .collection('users')
          .where('migrationToken', isEqualTo: migrationToken.value.text)
          .get();
      if (document.docs.isEmpty) {
        Keys.scaffoldMessengerKey.currentState!.showSnackBar(SnackBar(
          content: Text(
              'No token in database.\nPlease generate new token on your account you want to transfer'),
          backgroundColor: Colors.red,
        ));
      }
      if (!document.docs[0].exists) {
        Keys.scaffoldMessengerKey.currentState!.showSnackBar(SnackBar(
          content: Text(
              'No token in database.\nPlease generate new token on your account you want to transfer'),
          backgroundColor: Colors.red,
        ));
      }
      var user = document.docs[0]['user'];
      var secT = document.docs[0]['secretToken'];
      player.value = Player.fromJson(user);
      pref.setString('secretToken', secT);
      pref.setString('uid', player.value.uid);
      pref.setString('user', user);
      update();
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
}
