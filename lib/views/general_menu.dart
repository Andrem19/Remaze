import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remaze/controllers/ad_controller.dart';
import 'package:remaze/controllers/game_menu_controller.dart';
import 'package:remaze/controllers/main_game_controller.dart';
import 'package:remaze/controllers/routing/app_pages.dart';
import 'package:remaze/views/game/maze_game_act.dart';

import '../AppOpenAdManager.dart';

class GeneralMenu extends StatelessWidget {
  const GeneralMenu({super.key});

  @override
  Widget build(BuildContext context) {
    MainGameController mainCtrl = Get.find<MainGameController>();
    return GetBuilder<MainGameController>(builder: (controller) {
      return Scaffold(
        body: Center(
          child: Container(
            decoration: kIsWeb
                ? BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color.fromARGB(255, 72, 68, 68),
                    boxShadow: [
                      BoxShadow(color: Colors.green, spreadRadius: 3),
                    ],
                  )
                : const BoxDecoration(),
            width: kIsWeb ? Get.size.width / 3 : Get.size.width,
            child: Scaffold(
              appBar: AppBar(
                actions: [
                  Center(
                      child: Text(
                    'rank. ${controller.points.value ?? 0}',
                    style: TextStyle(fontSize: 20),
                  )),
                  SizedBox(
                    width: 5,
                  )
                ],
                title: Text(controller.player.value.userName),
              ),
              body: SingleChildScrollView(
                child: Center(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      InkWell(
                        onTap: () => controller.changeQrShow(),
                        child: Builder(builder: (context) {
                          if (controller.showQR.value) {
                            return Container(
                              color: Colors.white,
                              height: 200,
                              width: 200,
                              child: controller.createQR(),
                            );
                          } else {
                            return Container(
                              color: Colors.white,
                              height: 200,
                              width: 200,
                              child:
                                  Image.asset('assets/images/maze_preview.jpg'),
                            );
                          }
                        }),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: TextField(
                                onChanged: (value) {},
                                controller: controller.playerSearch,
                                keyboardType: TextInputType.text,
                                maxLines: 1,
                                decoration: InputDecoration(
                                    labelText: 'Player Name',
                                    prefixIcon: Icon(Icons.search),
                                    suffixIcon: InkWell(
                                        onTap: () {
                                          Get.toNamed(Routes.QR_SCANNER);
                                        },
                                        child: Icon(Icons.qr_code_2_sharp)),
                                    hintMaxLines: 1,
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.green, width: 4.0))),
                              ),
                            ),
                          ),
                          Flexible(
                              child: Padding(
                            padding: const EdgeInsets.only(left: 5.0),
                            child: ElevatedButton(
                              child: Text('BATTLE'),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  textStyle: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold)),
                              onPressed: () {
                                controller.invitePlayerForBattle();
                              },
                            ),
                          )),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: 200,
                          child: ElevatedButton(
                            child: Text('RIVAL SEARCH'),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey,
                                textStyle: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold)),
                            onPressed: () async {
                              var adCtrl = Get.find<AdController>();
                              if (adCtrl.interstitialVideoAd != null) {
                                await adCtrl.interstitialVideoAd?.show();
                              } else {
                                Get.toNamed(Routes.RIVAL_SEARCH);
                              }
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: 200,
                          child: ElevatedButton(
                            child: Text('MAPS QUESTS'),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey,
                                textStyle: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold)),
                            onPressed: () {
                              Get.toNamed(Routes.QUESTS);
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: 200,
                          child: ElevatedButton(
                            child: Text('LEADERBOARD'),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey,
                                textStyle: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold)),
                            onPressed: () {
                              Get.toNamed(Routes.GENERAL_LEADERBOARD);
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: 200,
                          child: ElevatedButton(
                            child: Text('MAP EDITOR'),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey,
                                textStyle: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold)),
                            onPressed: () {
                              Get.toNamed(Routes.EDIT_MENU);
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: 200,
                          child: ElevatedButton(
                            child: Text('SETTINGS'),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey,
                                textStyle: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold)),
                            onPressed: () {
                              Get.toNamed(Routes.SETTINGS);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
