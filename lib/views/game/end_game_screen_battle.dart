import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:remaze/controllers/fight_controller.dart';
import 'package:remaze/controllers/main_game_controller.dart';
import 'package:remaze/controllers/routing/app_pages.dart';

class EndGameScreenBattle extends StatelessWidget {
  const EndGameScreenBattle({super.key});

  @override
  Widget build(BuildContext context) {
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
              body: Center(
                child: Builder(
                  builder: (context) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(controller.YourCurrentRole.value == controller.vinner
                            ? 'YOU VINN'
                            : 'YOU LOSE', style: TextStyle(fontSize: 25, color: controller.YourCurrentRole.value == controller.vinner ? Colors.green : Colors.red, fontWeight: FontWeight.bold),),
                        ElevatedButton(
                            onPressed: () {
                              controller.deleteMultiplayerGameInstant();
                              Get.offNamed(Routes.GENERAL_MENU);
                            },
                            child: const Text('To Main Screen'))
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}