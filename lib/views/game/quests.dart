import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:remaze/controllers/game_act_controller.dart';
import 'package:remaze/controllers/game_menu_controller.dart';
import 'package:remaze/views/widgets/map_tile.dart';

import '../../controllers/routing/app_pages.dart';

class QuestsScreen extends StatelessWidget {
  const QuestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<GameMenuController>(
        builder: (controller) {
          return Center(
            child: Container(
              decoration: kIsWeb
                  ? BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color.fromARGB(255, 72, 68, 68),
                      boxShadow: [
                        BoxShadow(color: Colors.green, spreadRadius: 3),
                      ],
                    )
                  : const BoxDecoration(),
              width: kIsWeb ? Get.size.width / 3 : Get.size.width,
              child: Scaffold(
                appBar: AppBar(
                  title: Center(child: const Text('MAPS')),
                  centerTitle: true,
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
                body: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: TextField(
                        onChanged: (value) {
                          controller.search(value);
                        },
                        controller: controller.queryKey,
                        keyboardType: TextInputType.text,
                        maxLines: 1,
                        decoration: InputDecoration(
                            labelText: 'Map Name',
                            prefixIcon: Icon(Icons.search),
                            hintMaxLines: 1,
                            border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.green, width: 4.0))),
                      ),
                    ),
                    StreamBuilder(
                      stream: controller.maps,
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Text('Something went wrong');
                        }
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Text("Loading");
                        }
            
                        return ListView(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          children:
                              snapshot.data!.docs.map((DocumentSnapshot document) {
                            Map<String, dynamic> data =
                                document.data()! as Map<String, dynamic>;
                            return ListTile(
                              trailing: FittedBox(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(right: 8),
                                      child: InkWell(
                                        onTap: () {
                                          controller.loadMapChampions(data['id']);
                                          Get.toNamed(Routes.LEADERBOARD);
                                        },
                                        child: Icon(Icons.leaderboard),
                                      ),
                                    ),
                                    ElevatedButton(
                                      child: Text('PLAY'),
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              Color.fromARGB(255, 54, 244, 67),
                                          textStyle: const TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold)),
                                      onPressed: () {
                                        controller
                                            .prepareQuestGame(data['id'].toString());
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              leading: ConstrainedBox(
                                constraints: BoxConstraints(
                                  minWidth: 50,
                                  minHeight: 50,
                                  maxWidth: 50,
                                  maxHeight: 50,
                                ),
                                child: Image.asset('assets/images/maze_icon.png',
                                    fit: BoxFit.cover),
                              ),
                              title: Text(data['name'].toString()),
                              subtitle:
                                  Text(data['author'].toString().substring(0, 20)),
                            );
                          }).toList(),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
