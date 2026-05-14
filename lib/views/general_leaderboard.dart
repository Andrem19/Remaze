import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:remaze/controllers/game_menu_controller.dart';

import '../controllers/ad_controller.dart';

class GeneralLeaderboard extends StatelessWidget {
  const GeneralLeaderboard({super.key});

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
                title: Center(child: const Text('LEADERS')),
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
                  : SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: ListView(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        children: List.generate(
                          controller.leaders.value.length,
                          (index) {
                            return ListTile(
                              leading: Text(
                                (index + 1).toString(),
                                style: TextStyle(
                                    fontSize: 20, color: Colors.greenAccent),
                              ),
                              title: Text(controller.leaders.value[index].name),
                              trailing: Text(controller
                                  .leaders.value[index].points
                                  .toString()),
                            );
                          },
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
