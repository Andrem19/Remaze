import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remaze/controllers/main_game_controller.dart';
import 'package:remaze/controllers/routing/app_pages.dart';
import 'package:remaze/views/maze_game_act.dart';

class GeneralMenu extends StatelessWidget {
  const GeneralMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MainGameController>(
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            actions: [
              Center(child: Text('rank. ${controller.player.value.points ?? 0}', style: TextStyle(fontSize: 20),)),
              SizedBox(width: 5,)
            ],
            title: Text(controller.player.value.userName),
          ),
          body: Center(
            child: Column(
              children: [
                SizedBox(height: 10,),
                InkWell(
                  onTap: () => controller.changeQrShow(),
                  child: Builder(
                    builder: (context) {
                      if (controller.showQR.value) {
                        return Container(
                          color: Colors.white,
                          height: 250,
                          width: 250,
                          child: controller.createQR(),
                        // child: Image.asset('assets/images/maze_preview.jpg'),
                        );
                      } else {
                        return Container(
                          color: Colors.white,
                          height: 250,
                          width: 250,
                        child: Image.asset('assets/images/maze_preview.jpg'),
                        );
                      }
                    }
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: Get.size.width / 3,
                    child: ElevatedButton(
                      child: Text('START'),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey,
                          textStyle: const TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold)),
                      onPressed: () {
                        Get.toNamed(Routes.GAME_ACT);
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: Get.size.width / 3,
                    child: ElevatedButton(
                      child: Text('LEADERBOARD'),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey,
                          textStyle: const TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold)),
                      onPressed: () {

                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: Get.size.width / 3,
                    child: ElevatedButton(
                      child: Text('MAP EDITOR'),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey,
                          textStyle: const TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold)),
                      onPressed: () {
                        Get.toNamed(Routes.EDIT_MENU);
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: Get.size.width / 3,
                    child: ElevatedButton(
                      child: Text('SETTINGS'),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey,
                          textStyle: const TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold)),
                      onPressed: () {
                        Get.toNamed(Routes.SETTINGS);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }
    );
  }
}
