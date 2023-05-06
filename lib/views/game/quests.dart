import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:remaze/controllers/game_act_controller.dart';
import 'package:remaze/controllers/game_menu_controller.dart';
import 'package:remaze/views/widgets/map_tile.dart';

class QuestsScreen extends StatelessWidget {
  const QuestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GameMenuController>(builder: (controller) {
      return Scaffold(
        body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('questMaps')
                .orderBy('number', descending: false)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GridView.count(
                    crossAxisCount: 2,
                    children: snapshot.data!.docs.map((e) {
                      return InkWell(
                          onTap: () {
                            controller.prepareQuestGame(e['name']);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: MapTile(url: e['img']),
                          ));
                    }).toList(),
                  ),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 15,
                  ),
                );
              }
            }),
      );
    });
  }
}
