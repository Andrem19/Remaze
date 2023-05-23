import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:remaze/controllers/main_game_controller.dart';
import 'package:remaze/models/maze_map.dart';

class Control extends StatelessWidget {
  const Control({super.key});
  final double radiusCircle = 40;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MainGameController>(builder: (controller) {
      return Opacity(
        opacity: 0.5,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    controller.moveDir = Direction.up;
                  },
                  child: Container(
                    height: radiusCircle,
                    width: radiusCircle,
                    decoration: new BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Icon(Icons.arrow_circle_up),
                    ),
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    controller.moveDir = Direction.left;
                  },
                  child: Container(
                    height: radiusCircle,
                    width: radiusCircle,
                    decoration: new BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Icon(Icons.arrow_circle_left),
                    ),
                  ),
                ),
                SizedBox(width: radiusCircle,),
                InkWell(
                  onTap: () {
                    controller.moveDir = Direction.right;
                  },
                  child: Container(
                    height: radiusCircle,
                    width: radiusCircle,
                    decoration: new BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Icon(Icons.arrow_circle_right),
                    ),
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    controller.moveDir = Direction.down;
                  },
                  child: Container(
                    height: radiusCircle,
                    width: radiusCircle,
                    decoration: new BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Icon(Icons.arrow_circle_down),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      );
    });
  }
}
