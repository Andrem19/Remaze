// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:remaze/controllers/game_act_controller.dart';
import 'package:remaze/views/widgets/cube_widget.dart';
import 'package:remaze/views/widgets/skills_widget.dart';

import '../../models/maze_map.dart';

class MazeMapScreen extends StatelessWidget {
  MazeMapScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GameActController>(initState: (state) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
          overlays: [SystemUiOverlay.bottom]);
    }, dispose: (state) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
          overlays: SystemUiOverlay.values);
    }, builder: (controller) {
      return Stack(
        children: [
          GestureDetector(
            onDoubleTap: () {
              controller.showSkills.value = !controller.showSkills.value;
            },
            onPanUpdate: (DragUpdateDetails details) {
              if (details.delta.dx > 0) {
                controller.moveDirection.value = Direction.right;
              } else if (details.delta.dx < 0) {
                controller.moveDirection.value = Direction.left;
              } else if (details.delta.dy < 0) {
                controller.moveDirection.value = Direction.up;
              } else if (details.delta.dy > 0) {
                controller.moveDirection.value = Direction.down;
              }
            },
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children:
                    List.generate(controller.mazeMap.value.mazeMap.length, (row) {
                  return Expanded(
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: List.generate(
                            controller.mazeMap.value.mazeMap[row].length, (col) {
                          return Expanded(
                            child: CubeBrick(
                                cubeProto: controller.mazeMap.value.mazeMap[row]
                                    [col]),
                          );
                        })),
                  );
                }),
              ),
            ),
          ),
          Opacity(
            opacity: 0.5,
            child: Text(
              controller.timerText.value, 
              style: TextStyle(
                color: Colors.red, 
                fontSize: 20, 
                fontWeight: FontWeight.bold),)),
          SkillsWidget()
        ],
      );
    });
  }
}
