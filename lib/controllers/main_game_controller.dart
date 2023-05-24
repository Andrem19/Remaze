import 'dart:async';

import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:remaze/controllers/routing/app_pages.dart';
import 'package:remaze/models/maze_map.dart';
import 'package:remaze/models/palyer.dart';
import 'package:remaze/services/dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../AppOpenAdManager.dart';
import '../keys.dart';

class MainGameController extends GetxController with WidgetsBindingObserver {
  MazeMap? currentGameMap;
  String playerWhoIInvite_ID = '';
  bool IsUserInGame = false;
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
  String vinner = '';
  late Stream<DocumentSnapshot<Map<String, dynamic>>> snapshots;
  late StreamSubscription<DocumentSnapshot<Map<String, dynamic>>> listner;
  bool openDialog = false;

  TextEditingController targetQrCode = TextEditingController();
  Rx<TextEditingController> userNameController = TextEditingController().obs;
  Rx<String> migrationTokenGen = ''.obs;
  Rx<TextEditingController> migrationToken = TextEditingController().obs;
  TextEditingController playerSearch = TextEditingController(text: '');

  // AppOpenAdManager appOpenAdManager = AppOpenAdManager();
  bool isPaused = false;
  Direction moveDir = Direction.up;

  @override
  void onInit() async {
    // if (!kIsWeb) {
    //   appOpenAdManager.loadAd();
    //   WidgetsBinding.instance.addObserver(this);
    // }
    pref = await SharedPreferences.getInstance();
    // await pref.remove('secretToken');
    // await pref.remove('user');
    await authenticate();
    await loadAudioAssets();
    super.onInit();
  }

  @override
  void dispose() {
    destroyListner();
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   super.didChangeAppLifecycleState(state);
  //   if (state == AppLifecycleState.paused) {
  //     isPaused = true;
  //   }
  //   if (state == AppLifecycleState.resumed && isPaused) {
  //     print("RESUME -------");
  //     appOpenAdManager.showAdIfAvailable();
  //     isPaused = false;
  //   }
  // }

  void playButton() {
    FlameAudio.play('button_change_direction.ogg');
  }

  void invitePlayerForBattle() async {
    print(1);
    var doc = await firebaseFirestore
        .collection('users')
        .where('name', isEqualTo: playerSearch.text)
        .get();
    if (doc.docs.length > 0) {
      print(2);
      var data = doc.docs[0].data();
      bool status = data['isUserInGame'] as bool;
      if (status) {
        Keys.scaffoldMessengerKey.currentState!.showSnackBar(SnackBar(
          content: Text('This user currently playing another game'),
          backgroundColor: Colors.red,
        ));
        return;
      } else {
        print(3);
        changeStatusInGame(true);
        YourCurrentRole.value = 'A';
        playerWhoIInvite_ID = doc.docs[0].id;
        Get.toNamed(Routes.INVITE_BATTLE);
        playerSearch.clear();
      }
    }
  }

  void refreshUserState() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String uid = pref.getString('uid') ?? 'none';
    var document = await firebaseFirestore.collection('users').doc(uid).get();
    var me = document.data();
    points.value = me!['points'] as int;
    update();
  }

  void deleteMultiplayerGameInstant() async {
    var doc = await firebaseFirestore
        .collection('gameList')
        .doc(currentmultiplayerGameId)
        .get();
    if (doc.exists) {
      var data = doc.data();
      bool Player_A = data!['Player_A_ready'];
      bool Player_B = data['Player_B_ready'];
      if (!Player_A && !Player_B) {
        await firebaseFirestore
            .collection('gameList')
            .doc(currentmultiplayerGameId)
            .delete();
      }
    }
  }

  void deleteBattleGameInstant() async {
    var doc = await firebaseFirestore
        .collection('gameBattle')
        .doc(currentmultiplayerGameId)
        .get();
    if (doc.exists) {
      var data = doc.data();
      bool Player_A = data!['Player_A_ready'];
      bool Player_B = data['Player_B_ready'];
      if (!Player_A && !Player_B) {
        await firebaseFirestore
            .collection('gameBattle')
            .doc(currentmultiplayerGameId)
            .delete();
      }
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
    await firebaseFirestore.collection('users').doc(player.value.uid).update({
      'isUserInGame': false,
      'isAnybodyAscMe': false,
    });
    await setUpListner(player.value.uid);
  }

  Future<void> setUpListner(String userId) async {
    snapshots =
        FirebaseFirestore.instance.collection('users').doc(userId).snapshots();
    listner = snapshots.listen((data) {
      bool isAnybodyAscMe = data['isAnybodyAscMe'];
      String whoAskMe = data['whoInviteMeToPlay'];
      String theGameIdInviteMe = data['theGameIdInviteMe'];
      print('game_id: $theGameIdInviteMe');
      if (isAnybodyAscMe) {
        firebaseFirestore.collection('users').doc(player.value.uid).update({
          'isAnybodyAscMe': false,
        });
        changeStatusInGame(true);
        Get.dialog(AlertDialog(
            title: Text('$whoAskMe invite your to the game'),
            content: const Text('Do you want to play?'),
            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    textStyle: const TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold)),
                onPressed: () {
                  changeStatusInGame(false);
                  firebaseFirestore
                      .collection('gameBattle')
                      .doc(theGameIdInviteMe)
                      .update({
                    'IcantPlay': true,
                  });
                  Get.back();
                },
                child: Text(
                  'NO',
                  style: TextStyle(color: Colors.white, fontSize: 16.0),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    textStyle: const TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold)),
                onPressed: () {
                  agreeToPlayPreparing(theGameIdInviteMe);
                },
                child: Text(
                  'YES',
                  style: TextStyle(color: Colors.white, fontSize: 16.0),
                ),
              ),
            ]));
      }
    });
  }

  Future<void> agreeToPlayPreparing(String theGameIdInviteMe) async {
    try {
      firebaseFirestore.collection('gameBattle').doc(theGameIdInviteMe).update({
        'Player_B_uid': player.value.uid,
        'Player_B_Name': player.value.uid,
        'gameStatus': 'waiting'
      });
      var doc = await firebaseFirestore
          .collection('gameBattle')
          .doc(theGameIdInviteMe)
          .get();

      if (doc.exists) {
        var data = doc.data();

        currentMapId = data!['Map_Id'];
        var maps = await FirebaseFirestore.instance
            .collection('maps')
            .where('id', isEqualTo: currentMapId)
            .get();
        if (maps.docs.length > 0) {
          var data = maps.docs[0].data();
          currentGameMap = MazeMap.fromJson(data['map']);
          prepareMapToGame();
        }
        currentmultiplayerGameId = theGameIdInviteMe;
        currentMapName = data['MapName'];
        YourCurrentRole.value = 'B';
      }
      Get.toNamed(Routes.INVITE_BATTLE);
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

  void prepareMapToGame() {
    currentGameMap!.shaddowRadius = 5;
  }

  void changeStatusInGame(bool status) {
    firebaseFirestore.collection('users').doc(player.value.uid).update({
      'isUserInGame': status,
    });
    IsUserInGame = status;
  }

  void destroyListner() {
    listner.cancel();
    changeStatusInGame(false);
  }

  Future<void> checkUserAuth() async {
    String uid = pref.getString('uid') ?? 'none';
    String secretT = pref.getString('secretToken') ?? 'none';
    if (uid == 'none') {
      registerNewUser();
    }
    try {
      var document = await firebaseFirestore.collection('users').doc(uid).get();
      if (document.exists) {
        var data = document.data();
        Player recivedPlayer = Player.fromJson(data!['user']);
        String token = data['secretToken'];
        if (secretT != token) {
          registerNewUser();
        }
        points.value = data['points'];
        player.value = recivedPlayer;
      } else {
        registerNewUser();
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

  Future<void> registerNewUser() async {
    String uid = uuid.v4();
    String part = uid.substring(30);
    String secrTok = uuid.v4();

    Player pl = Player(uid: uid, userName: 'Pl-$part');
    try {
      await firebaseFirestore.collection('users').doc(uid).set({
        'user': pl.toJson(),
        'name': 'Pl-$part',
        'secretToken': secrTok,
        'migrationToken': '',
        'isUserInGame': false,
        'isAnybodyAscMe': false,
        'whoInviteMeToPlay': '',
        'theGameIdInviteMe': '',
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

  Future<void> updateName() async {
    String normalizedName =
        userNameController.value.text.replaceAll(RegExp(r'\s+'), '');
    await checkUserAuth();
    bool res = await chekNameExist(normalizedName);
    if (res) {
      return;
    }
    try {
      player.value.userName = normalizedName;
      var user = await firebaseFirestore
          .collection('users')
          .doc(player.value.uid)
          .get();
      if (user.exists) {
        await firebaseFirestore
            .collection('users')
            .doc(player.value.uid)
            .update({
          'name': normalizedName,
          'user': player.value.toJson(),
        });
        await pref.setString('user', player.value.toJson());
        update();
        Keys.scaffoldMessengerKey.currentState!.showSnackBar(SnackBar(
          content: Text('Name updated'),
          backgroundColor: Color.fromARGB(255, 54, 244, 67),
        ));
        Get.back();
      } else {
        Keys.scaffoldMessengerKey.currentState!.showSnackBar(SnackBar(
          content: Text('User does not auth'),
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

  Future<void> loadAudioAssets() async {
    await FlameAudio.audioCache
        .loadAll(['button_change_direction.ogg', 'maze_general_theme.mp3', 'teleport.mp3', 'freeze.wav', 'victory.wav']);
  }

  Future<bool> chekNameExist(String name) async {
    try {
      var doc = await firebaseFirestore
          .collection('users')
          .where('name', isEqualTo: name)
          .get();
      if (doc.docs.length > 0) {
        Keys.scaffoldMessengerKey.currentState!.showSnackBar(SnackBar(
          content: Text('This name exist. Create another name'),
          backgroundColor: Colors.red,
        ));
        return true;
      } else {
        return false;
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
