import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:remaze/controllers/fight_controller.dart';

class WaitingScreen extends StatelessWidget {
  const WaitingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FightController>(builder: (controller) {
      return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
            ),
          ),
          body: Center(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/maze_icon.png', height: 30, width: 30,),
                    Text('name of map')
                  ],
                ),
                Text('Status of game'),
                
              ],
            ),
          ));
    });
  }
}
