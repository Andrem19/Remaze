import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remaze/controllers/routing/app_pages.dart';
import 'package:remaze/views/maze_game_act.dart';

class GeneralMenu extends StatelessWidget {
  const GeneralMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Andrem"),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: Get.size.height / 3,
              width: Get.size.width / 1.8,
              child: Image.asset('assets/images/maze_preview.jpg'),
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
                    Get.toNamed(Routes.MAP_EDITOR);
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

                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
