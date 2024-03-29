import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remaze/controllers/game_menu_controller.dart';

import '../controllers/ad_controller.dart';
import '../controllers/main_game_controller.dart';

class LeaderBoardScreen extends StatelessWidget {
  const LeaderBoardScreen({super.key});
  Future<void> onBackPressed() async {
    var adCtrl = Get.find<AdController>();
    if (adCtrl.interstitialAd != null) {
      adCtrl.interstitialAd?.show();
    } else {
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GameMenuController>(builder: (controller) {
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
                  title: Center(child: const Text('CHAMPIONS')),
                  leading: IconButton(
                    onPressed: () async {
                      await onBackPressed();
                    },
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                    ),
                  ),
                ),
                body: controller.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : Column(
                        children: [
                          ListView(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              children: List.generate(
                                  controller.mapChampions.value.length,
                                  (index) {
                                return ListTile(
                                  leading: Text(
                                    (index + 1).toString(),
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.greenAccent),
                                  ),
                                  title: Text(controller
                                      .mapChampions.value[index].name),
                                  trailing: Text(controller
                                          .mapChampions.value[index].seconds
                                          .toString() +
                                      ' ' +
                                      'sec'),
                                );
                              })),
                        ],
                      )),
          ),
        ),
      );
    });
  }
}
