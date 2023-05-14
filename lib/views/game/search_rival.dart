import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:remaze/controllers/fight_controller.dart';
import 'package:remaze/controllers/game_menu_controller.dart';
import 'package:remaze/controllers/routing/app_pages.dart';
import 'package:remaze/controllers/search_rival_controller.dart';

class WaitingScreen extends StatelessWidget {
  const WaitingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SearchRivalController>(builder: (controller) {
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
                  leading: IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                    ),
                  ),
                ),
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/maze_icon.png',
                              height: 40,
                              width: 40,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(controller.nameOfMap.value),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(controller.gameStatus.value),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          child: Text('PLAY'),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              textStyle: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold)),
                          onPressed: controller.startButtonShow.value
                              ? () {
                                  controller.toPlay();
                                }
                              : null,
                        ),
                      ),
                    ],
                  ),
                )),
          ),
        ),
      );
    });
  }
}
