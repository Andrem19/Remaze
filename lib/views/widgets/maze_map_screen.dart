// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:remaze/controllers/game_act_controller.dart';
import 'package:remaze/views/widgets/controll.dart';
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
          Container(
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
          Row(
            children: [
              Opacity(
                opacity: 0.5,
                child: Text(
                  controller.timerText.value, 
                  style: TextStyle(
                    color: Colors.red, 
                    fontSize: 20, 
                    fontWeight: FontWeight.bold),)),
                    SizedBox(width: 10,),
                    Text(controller.textMessage.value, style: TextStyle(color: Colors.red),),
            ],
          ),
          Positioned(
            bottom: 15,
            right: 15,
            child: Control()),
        ],
      );
    });
  }
}
