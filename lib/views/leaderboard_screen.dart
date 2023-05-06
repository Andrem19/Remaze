import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/main_game_controller.dart';

class LeaderBoardScreen extends StatelessWidget {
  const LeaderBoardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MainGameController>(builder: (controller) {
      return Scaffold(
        body: Center(
          child: Column(
            children: [
              Text('LeaderBoard'),
            ],
          ),
        ),
      );
    });
  }
}
