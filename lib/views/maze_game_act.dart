import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:remaze/views/maze_map_screen.dart';

class MazeGameAct extends StatelessWidget {
  MazeGameAct({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: kIsWeb ? Get.size.width / 3 : Get.size.width,
          child: MazeMapScreen(),
        ),
      ),
    );
  }
}
