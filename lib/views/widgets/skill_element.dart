// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remaze/controllers/fight_controller.dart';

import 'package:remaze/controllers/game_act_controller.dart';

class SkillElement extends StatelessWidget {
  String img;
  String text = '';
  bool activate;
  SkillElement({
    Key? key,
    required this.img,
    required this.text,
    required this.activate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FightController>(builder: (controller) {
      return Opacity(
        opacity: activate ? 0.4 : 0.7,
        child: Stack(
          alignment: Alignment.center,
          children: [
            CircleAvatar(
              backgroundColor: Colors.black,
              // radius: activate ? Get.size.width / 25 : Get.size.width / 11,
              child: CircleAvatar(
                radius: Get.size.width / 11,
                backgroundImage: AssetImage(img),
              ),
            ),
            Center(
                child: Text(
              text,
              style: TextStyle(fontSize: activate ? 10 : 20),
            ))
          ],
        ),
      );
    });
  }
}
