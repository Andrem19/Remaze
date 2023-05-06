import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remaze/controllers/game_act_controller.dart';
import 'package:remaze/controllers/game_menu_controller.dart';

import '../../controllers/routing/app_pages.dart';

class StartMenu extends StatelessWidget {
  const StartMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GameMenuController>(builder: (controller) {
      return Scaffold(
        body: Center(
          child: Column(
            children: [
              SizedBox(height: Get.size.height /3,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: Get.size.width / 3,
                  child: ElevatedButton(
                    child: Text('QUESTS'),
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
