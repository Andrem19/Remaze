import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remaze/controllers/game_act_controller.dart';
import 'package:remaze/controllers/game_menu_controller.dart';
import 'package:remaze/controllers/main_game_controller.dart';

import '../../controllers/routing/app_pages.dart';

class StartMenu extends StatelessWidget {
  StartMenu({super.key});

  @override
  @override
  Widget build(BuildContext context) {
    MainGameController mainCtrlr = Get.find<MainGameController>();
    return GetBuilder<GameMenuController>(builder: (controller) {
      return Scaffold(
        appBar: AppBar(
          actions: [
            Center(
                child: Text(
              'rank. ${mainCtrlr.points.value ?? 0}',
              style: TextStyle(fontSize: 20),
            )),
            SizedBox(
              width: 5,
            )
          ],
          title: Text(mainCtrlr.player.value.userName),
        ),
        body: Center(
          child: Column(
            children: [
              SizedBox(
                height: Get.size.height / 3,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: Get.size.width / 3,
                  child: ElevatedButton(
                    child: Text('MAPS'),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                        textStyle: const TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold)),
                    onPressed: () {
                      Get.toNamed(Routes.QUESTS);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
