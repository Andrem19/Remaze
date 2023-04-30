import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:remaze/views/widgets/maze_map_widget.dart';

class MazeGameAct extends StatelessWidget {
  const MazeGameAct({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: MazeMapScreen(),
      ),
    );
  }
}