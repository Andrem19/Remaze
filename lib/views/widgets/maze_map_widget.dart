import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:remaze/controllers/game_act_controller.dart';
import 'package:remaze/views/widgets/cube_widget.dart';

import '../../models/maze_map.dart';

class MazeMapScreen extends StatelessWidget {
  const MazeMapScreen({super.key});

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
                children: List.generate(controller.mazeMap.value.mazeMap.length,
                    (row) {
                  return Expanded(
                    child: Row(
                        children: List.generate(
                            controller.mazeMap.value.mazeMap[row].length,
                            (col) {
                      return CubeBrick(
                          cubeProto: controller.mazeMap.value.mazeMap[row]
                              [col]);
                    })),
                  );
                }),
              ),
            ),
          ),
          Builder(
            builder: (context) {
              if (controller.showSkills.value) {
                return Column(
                  children: [
                    SizedBox(height: Get.size.width /8,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          onTap: () {},
                          child: Opacity(
                            opacity: 0.4,
                            child: CircleAvatar(
                              backgroundColor: Colors.black,
                              radius: Get.size.width / 11,
                              child: CircleAvatar(
                                radius: Get.size.width / 12,
                                backgroundImage:
                                    AssetImage('assets/images/snowflake.jpg'),
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {},
                          child: Opacity(
                            opacity: 0.4,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                CircleAvatar(
                                backgroundColor: Colors.black,
                                radius: Get.size.width / 11,
                                child: CircleAvatar(
                                  radius: Get.size.width / 12,
                                  backgroundImage:
                                      AssetImage('assets/images/teleport.jpg'),
                                ),
                              ),
                              Center(child: const Text('In', style: TextStyle(fontSize: 20),))
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {},
                          child: Opacity(
                            opacity: 0.4,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                CircleAvatar(
                                backgroundColor: Colors.black,
                                radius: Get.size.width / 11,
                                child: CircleAvatar(
                                  radius: Get.size.width / 12,
                                  backgroundImage:
                                      AssetImage('assets/images/teleport.jpg'),
                                ),
                              ),
                              Center(child: const Text('Out', style: TextStyle(fontSize: 20),))
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              } else {
                return SizedBox();
              }
            },
          )
        ],
      );
    });
  }
}
