import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remaze/controllers/game_menu_controller.dart';

import '../controllers/main_game_controller.dart';

class LeaderBoardScreen extends StatelessWidget {
  const LeaderBoardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GameMenuController>(builder: (controller) {
      return Scaffold(
          appBar: AppBar(
            title: Center(child: const Text('CHAMPIONS')),
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
          body: controller.isLoading ? const Center(child: CircularProgressIndicator()) : Column(
            children: [
              ListView(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  children:
                      List.generate(controller.mapChampions.value.length, (index) {
                    return ListTile(
                      leading: Text((index + 1).toString(), style: TextStyle(fontSize: 20, color: Colors.greenAccent),),
                      title: Text(controller.mapChampions.value[index].name),
                      trailing: Text(controller.mapChampions.value[index].seconds.toString() + ' ' + 'sec'),
                    );
                  })),
            ],
          ));
    });
  }
}
