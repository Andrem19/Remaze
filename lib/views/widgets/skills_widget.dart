// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remaze/controllers/fight_controller.dart';

import 'package:remaze/controllers/game_act_controller.dart';
import 'package:remaze/views/widgets/skill_element.dart';

class SkillsWidget extends StatelessWidget {
  SkillsWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FightController>(
      builder: (controller) {
        if (controller.showSkills.value) {
          return Container(
            width: kIsWeb ? Get.size.width / 3 : Get.size.width,
            height: Get.size.height /4,
            child: Column(
              children: [
                SizedBox(
                  height: Get.size.height / 8,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                        onTap: () {
                          controller.setUpFrozen();
                        },
                        child: SkillElement(
                          activate: controller.frozenActivate,
                          img: 'assets/images/snowflake.jpg',
                          text: '',
                        )),
                    InkWell(
                        onTap: () {
                          controller.setUpDoor();
                        },
                        child: SkillElement(
                          activate: controller.teleportDoor,
                          img: 'assets/images/teleport.jpg',
                          text: 'In',
                        )),
                    InkWell(
                        onTap: () {
                          controller.setUpExit();
                        },
                        child: SkillElement(
                          activate: controller.teleportExit,
                          img: 'assets/images/teleport.jpg',
                          text: 'Out',
                        )),
                  ],
                ),
              ],
            ),
          );
        } else {
          return SizedBox();
        }
      },
    );
  }
}
